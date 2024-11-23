# Map of tags to apply to resources
variable "tags" {
  type = map(string)
}

# Name of the VPC for the EKS cluster
variable "vpc_name" {
  type        = string
  default     = "eks_cluster_vpc"
  description = "This is the default name for the EKS cluster VPC"
}

# Enables DNS support in the VPC (true/false)
variable "dns_support" {
  type = string
}

# Enables DNS hostnames in the VPC (true/false)
variable "dns_hostnames" {
  type = string
}

# CIDR block for the VPC
variable "cidr_block" {
  description = "Default CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Private subnet definitions
variable "private_subnets" {
  description = "Private subnets with their respective index in availability zones"
  default = {
    "private_subnet_1" = 0
    "private_subnet_2" = 1
  }
}

# Public subnet definitions
variable "public_subnets" {
  description = "Public subnets with their respective index in availability zones"
  default = {
    "public_subnet_1" = 0
    "public_subnet_2" = 1
  }
}

# AWS region where the resources will be deployed
variable "region" {
}