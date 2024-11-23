# EKS Cluster Version
variable "eks_version" {
  type = string
  description = "EKS Cluster Version"
}

# Private subnets for the cluster
variable "private_subnets" {
}

# Public subnets for the cluster
variable "public_subnets" {
}

# Desired number of worker nodes for the cluster
variable "desired_size" {
  type = number
  default = 2
  description = "Desired number of worker nodes for the cluster"
}

# Minimum number of worker nodes available for the cluster
variable "min_size" {
  type = number
  default = 1
  description = "Minimum number of worker nodes available for the cluster"
}

# Maximum number of worker nodes available for the cluster
variable "max_size" {
  type = number
  default = 3
  description = "Maximum number of worker nodes available for the cluster"
}

# AMI type for nodes
variable "ami_type" {
  type = string
  description = "AMI type for nodes"
}

# List of instance types for the worker nodes
variable "instance_type" {
  type = list(string)
  default = ["t2.small"]
}

# Capacity type for worker nodes
variable "capacity_type" {
  type = string
  description = "Capacity type for worker nodes"
}

# Disk size for worker nodes in GB
variable "disk_size" {
  type = string
  default = 50
  description = "Disk size for worker nodes"
}

# Maximum number of worker nodes unavailable during scaling updates
variable "max_unavailable" {
  type = string
  default = 1
  description = "Maximum number of worker nodes unavailable"
}

# Tags for resources
variable "tags" {
}


# Roles object containing IAM roles for cluster and worker nodes
variable "roles" {
  type = object({
    cluster_role              = string 
    worker_node_role          = string  
    eks_autoscaling_policy_arn = string  
  })
}


# Attachments object for IAM policy attachments to roles
variable "attachments" {
}