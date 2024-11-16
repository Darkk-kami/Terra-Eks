module "eks" {
  source = "infrastructure"
  region = "us-east-1"
  dns_hostnames = true
  dns_support = true
  eks_version = "1.31"
  ami_type = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
}

output "endpoint" {
  value = module.eks.endpoint
}

output "cluster-ca" {
  value = module.eks.kubeconfig-ca
}

