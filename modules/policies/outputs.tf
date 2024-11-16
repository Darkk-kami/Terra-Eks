output "roles" {
  description = "A collection of EKS-related IAM roles"
  value = {
    cluster_role              = aws_iam_role.cluster_role.arn
    worker_node_role          = aws_iam_role.worker_node_role.arn
    eks_autoscaling_policy_arn = aws_iam_policy.eks_autoscaling_policy.arn
  }
}

output "attachments" {
  description = "A collection of IAM policy attachments for EKS"
  value = {
    cluster_role_policy_attachment = aws_iam_role_policy_attachment.cluster_role_policy_attach
    CNI_policy_attachment          = aws_iam_role_policy_attachment.CNI_policy_attachment
    EC2CR_policy_attachment        = aws_iam_role_policy_attachment.EC2CR_policy_attachment
    worker_node_role_policy_attach = aws_iam_role_policy_attachment.worker_node_role_policy_attach
    EKSAutoScaling_policy_attachment = aws_iam_role_policy_attachment.EKSAutoScaling_policy_attachment
    ALB_controller_attachment = aws_iam_role_policy_attachment.ALB_controller_attachment
  }
}
