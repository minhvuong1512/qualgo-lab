output "configure_kubectl" {
  description = "Command to update kubeconfig for this cluster"
  value       = module.qualgo_lab_eks.configure_kubectl
}
