# Output EKS cluster API endpoint
output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

# Output EKS cluster certificate authority data for kubeconfig
output "kubeconfig-ca" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}
