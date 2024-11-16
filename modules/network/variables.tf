variable "tags" {
  type = map(string)
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
