variable "region" {
}

variable "tags" {
  type = map(string)
  default = {
    name = "my_eks_cluster"
  }
  description = "The default tag for all resources"
}

variable "vpc_name" {
  type = string
  default = "eks_cluster_vpc"
  description = "This is the default name for the eks cluster vpc"
}

variable "dns_support" {
  type = string
}

variable "dns_hostnames" {
  type = string
}

variable "cidr_block" {
  description = "Default cidr block for the vpc"
  type = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "Private subnets"
  default = {
    "private_subnet_1" = 0
    "private_subnet_2" = 1
  }
}

variable "public_subnets" {
  description = "Public Subnets"
  default = {
    "public_subnet_1" = 0
    "public_subnet_2" = 1
  }
}

# EKS Build Variables
variable "eks_version" {
  type = string
  description = "EKS Cluster Version"
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