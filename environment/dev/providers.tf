provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "terraformstatebucketeks"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}

