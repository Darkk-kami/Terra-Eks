module "policies" {
  source = "../../modules/policies"
  s3_bucket = module.storage.s3_bucket_name
}

module "storage" {
  source = "../../modules/storage"
}

module "networks" {
  source = "../../modules/network"
  dns_hostnames = "true"
  dns_support = "true"
  tags = {
    name = "eks_cluster"
  }
}

module "compute" {
  source = "../../modules/compute"
  tags = {
    name = "eks_cluster"
  }
  public_subnets = module.networks.public_subnets
  private_subnets =module.networks.private_subnets
  eks_version = "1.31"
  ami_type = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  roles       = module.policies.roles
  attachments = module.policies.attachments
}