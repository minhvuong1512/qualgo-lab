locals {
  istio_labels = {
    istio-injection = "enabled"
  }

  kubeconfig = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = "terraform"
    clusters = [{
      name = module.qualgo_lab_eks.eks_cluster_id
      cluster = {
        certificate-authority-data = module.qualgo_lab_eks.cluster_certificate_authority_data
        server                     = module.qualgo_lab_eks.cluster_endpoint
      }
    }]
    contexts = [{
      name = "terraform"
      context = {
        cluster = module.qualgo_lab_eks.eks_cluster_id
        user    = "terraform"
      }
    }]
    users = [{
      name = "terraform"
      user = {
        token = data.aws_eks_cluster_auth.this.token
      }
    }]
  })
}

module "container_images" {
  source = "../../lib/images"

  container_image_overrides = var.container_image_overrides
}

resource "null_resource" "cluster_blocker" {
  triggers = {
    "blocker" = module.qualgo_lab_eks.cluster_blocker_id
  }
}

resource "null_resource" "addons_blocker" {
  triggers = {
    "blocker" = module.qualgo_lab_eks.addons_blocker_id
  }
}

resource "time_sleep" "workloads" {
  create_duration  = "30s"
  destroy_duration = "60s"

  depends_on = [
    null_resource.addons_blocker
  ]
}

resource "kubernetes_namespace_v1" "nestjs_backend" {
  depends_on = [
    time_sleep.workloads
  ]

  metadata {
    name = "nestjs_backend"

    labels = var.istio_enabled ? local.istio_labels : {}
  }
}

resource "helm_release" "nestjs_backend" {
  name  = "nestjs_backend"
  chart = "../../../kubernetes/charts/nestjs-backend"

  namespace = kubernetes_namespace_v1.nestjs_backend.metadata[0].name
  values = [
    templatefile("${path.module}/values/nestjs-backend.yaml", {
      image_repository              = module.container_images.result.nestjs_backend.repository
      image_tag                     = module.container_images.result.nestjs_backend.tag
      opentelemetry_enabled         = var.opentelemetry_enabled
      opentelemetry_instrumentation = local.opentelemetry_instrumentation
    })
  ]
}


resource "kubernetes_namespace_v1" "nextjs-fronend-ui" {
  depends_on = [
    time_sleep.workloads
  ]

  metadata {
    name = "nextjs-fronend-ui"

    labels = var.istio_enabled ? local.istio_labels : {}
  }
}

resource "helm_release" "nextjs-fronend-ui" {
  depends_on = [
    helm_release.nestjs_backend
  ]

  name  = "nextjs-fronend-ui"
  chart = "../../../kubernetes/charts/nextjs"

  namespace = kubernetes_namespace_v1.nextjs-fronend-ui.metadata[0].name

  values = [
    templatefile("${path.module}/values/nextjs-frontend-ui.yaml", {
      image_repository              = module.container_images.result.nextjs-fronend-ui.repository
      image_tag                     = module.container_images.result.nextjs-fronend-ui.tag
      opentelemetry_enabled         = var.opentelemetry_enabled
      opentelemetry_instrumentation = local.opentelemetry_instrumentation
      istio_enabled                 = var.istio_enabled
    })
  ]
}

resource "time_sleep" "restart_pods" {
  triggers = {
    opentelemetry_enabled = var.opentelemetry_enabled
  }

  create_duration = "30s"

  depends_on = [
    helm_release.nextjs-fronend-ui
  ]
}

resource "null_resource" "restart_pods" {
  depends_on = [time_sleep.restart_pods]

  triggers = {
    opentelemetry_enabled = var.opentelemetry_enabled
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = base64encode(local.kubeconfig)
    }

    command = <<-EOT
      kubectl delete pod -A -l app.kuberneres.io/owner=qualgo-lab-sample --kubeconfig <(echo $KUBECONFIG | base64 -d)
    EOT
  }
}
