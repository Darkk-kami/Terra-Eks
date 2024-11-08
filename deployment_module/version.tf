terraform {
  required_version = ">= 1.9.5"
  required_providers {
    aws = {
      version = ">= 5.75.0"
    }

    kubernetes = {
      version = ">=2.33.0"
    }
  }
}