provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host = data.aws_eks_cluster.eks_cluster.endpoint
  token = data.aws_eks_cluster_auth.eks_cluster_auth.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
}

provider "helm" {
  kubernetes {
    host = data.aws_eks_cluster.eks_cluster.endpoint
    token = data.aws_eks_cluster_auth.eks_cluster_auth.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  }
}

terraform {
  backend "s3" {
    bucket = "terraformstatebucketeks"
    key = "app/terraform.tfstate"
    region = "us-east-1"
  }
}