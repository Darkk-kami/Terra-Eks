# EKS Build Variables
variable "eks_version" {
  type = string
  description = "EKS Cluster Version"
}

variable "private_subnets" {
}

variable "public_subnets" {
}

variable "desired_size" {
  type = number
  default = 2
  description = "Desired number of worker nodes for the cluster"
}

variable "min_size" {
  type = number
  default = 1
  description = "Minimum number of worker nodes available for the cluster"
}

variable "max_size" {
  type = number
  default = 3
  description = "Maximum number of worker nodes available for the cluster"
}

variable "ami_type" {
  type = string
  description = "AMI type for nodes"
}

variable "instance_type" {
  type = list(string)
  default = ["t2.small"]
}

variable "capacity_type" {
  type = string
  description = "Capacity type for worker nodes"
}

variable "disk_size" {
  type = string
  default = 50
  description = "Disk size for worker nodes"
}

variable "max_unavailable" {
  type = string
  default = 1
  description = "Maximum number of worker nodes unavailable"
}

variable "tags" {
}

variable "roles" {
  type = object({
    cluster_role              = string
    worker_node_role          = string
    eks_autoscaling_policy_arn = string
  })
}

variable "attachments" {
  # type = object({
  #   cluster_role_policy_attachment = string
  #   CNI_policy_attachment          = string
  #   EC2CR_policy_attachment        = string
  #   worker_node_role_policy_attach = string
  #   EKSAutoScaling_policy_attachment = string
  # })
}