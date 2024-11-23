module "policies" {
  source = "../../modules/policies"
}

module "storage" {
  source = "../../modules/storage"
  vpc_endpoint = module.networks.vpc_endpoint
  destination_bucket = "replication-bucket-89"
}

module "networks" {
  source = "../../modules/network"
  dns_hostnames = "true"
  dns_support = "true"
  tags = {
    name = "eks_cluster"
  }
  region = var.region
}

module "cluster" {
  source = "../../modules/cluster"
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


# module "lambda" {
#   source = "../../modules/lambda"
#   aws_account_id = ""
#   email = ""
# }
