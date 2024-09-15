terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

provider "aws" {
}

provider "kubernetes" {
  host                   = module.qualgo_lab_eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.qualgo_lab_eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "kubernetes" {
  alias = "cluster"

  host                   = module.qualgo_lab_eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.qualgo_lab_eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "kubectl" {
  apply_retry_count      = 10
  host                   = module.qualgo_lab_eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.qualgo_lab_eks.cluster_certificate_authority_data)
  load_config_file       = false
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.qualgo_lab_eks.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.this.token
    cluster_ca_certificate = base64decode(module.qualgo_lab_eks.cluster_certificate_authority_data)
  }
}
