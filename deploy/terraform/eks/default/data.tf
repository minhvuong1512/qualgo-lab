data "aws_region" "current" {}

data "aws_eks_cluster_auth" "this" {
  name = module.qualgo_lab_eks.eks_cluster_id

  depends_on = [
    null_resource.cluster_blocker
  ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.qualgo_lab_eks.eks_cluster_id
}