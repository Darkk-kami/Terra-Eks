# EKS Cluster Creation
resource "aws_eks_cluster" "eks_cluster" {
  name     = "my_eks_cluster"  
  role_arn = var.roles.cluster_role  
  version  = var.eks_version 

  # VPC configuration for the EKS cluster
  vpc_config {
    subnet_ids = concat(
      values(var.private_subnets)[*].id, 
      values(var.public_subnets)[*].id   
    )
  }

  depends_on = [var.attachments]  # Ensures that IAM roles are created before the EKS cluster
  tags = var.tags 
}

# EKS Node Group Creation
resource "aws_eks_node_group" "Node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name  
  node_group_name = "eks_node_group"  
  node_role_arn   = var.roles.worker_node_role
  subnet_ids      = values(var.private_subnets)[*].id 

  # Scaling configuration for the node group
  scaling_config {
    desired_size = var.desired_size 
    max_size     = var.max_size      
    min_size     = var.min_size      
  }

  # Update configuration for the node group
  update_config {
    max_unavailable = var.max_unavailable  # Max unavailable nodes during updates
  }

  ami_type        = var.ami_type  
  instance_types  = var.instance_type  
  capacity_type   = var.capacity_type  

  depends_on = [var.attachments] 
  tags = var.tags 
}
