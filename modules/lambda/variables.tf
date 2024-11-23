# Name of the EKS Cluster
variable "name" {
  default = "eks_cluster"
  type    = string
}

# Name of the S3 bucket used for storing Terraform state
variable "s3_bucket_name" {
  default = "terraformstatebucketeks"
}

# AWS region where resources will be created
variable "aws_region" {
  default = "us-east-1"
}

# AWS Account ID for resource identification
variable "aws_account_id" {
}

variable "email" {
}

