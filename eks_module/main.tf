# VPC for EKS EKS CLuster
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_support = var.dns_support
  enable_dns_hostnames = var.dns_hostnames
  tags = var.tags
}

#Find available zones based on provided region
data "aws_availability_zones" "available_azs" {}

# Resources for Public and Private VPC Subnets
resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnets
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available_azs.names)[each.value]
  tags = var.tags
}

resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, each.value+100)
  availability_zone = tolist(data.aws_availability_zones.available_azs.names)[each.value]
  tags = var.tags
}

# Resource for internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = var.tags
}

# Resource for Nat gateway
resource "aws_eip" "eks_nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "eks_nat_gw" {
  allocation_id = aws_eip.eks_nat_eip.id
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id

  tags = var.tags
  depends_on = [aws_internet_gateway.internet_gateway]
}

#resources and associations for route tables
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = var.tags
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = var.tags
}

# Create a route to the NAT gateway for the private subnet
resource "aws_route" "private_subnet_nat_gateway_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_nat_gw.id
}

resource "aws_route_table_association" "private_route_table_association" {
  depends_on     = [aws_subnet.private_subnets]
  route_table_id = aws_route_table.private_route_table.id
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "public_route_table_association" {
  depends_on     = [aws_subnet.public_subnets]
  route_table_id = aws_route_table.public_route_table.id
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
}

# Resource for Cluster Role

resource "aws_iam_role" "cluster_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role" "worker_node_role" {
  name = "worker_node_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


# IAM policy resource for Autoscaling
resource "aws_iam_policy" "eks_autoscaling_policy" {
  name = "EksAutoScalingPolicy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeScalingActivities",
                "autoscaling:DescribeTags",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeImages",
                "ec2:GetInstanceTypesFromInstanceRequirements",
                "eks:DescribeNodegroup"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
  })
}

# Attach policies to the cluster and Worker Node roles
resource "aws_iam_role_policy_attachment" "cluster_role_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_iam_role_policy_attachment" "worker_node_role_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "CNI_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "EC2CR_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "EKSAutoScaling_policy_attachment" {
  policy_arn = aws_iam_policy.eks_autoscaling_policy.arn
  role       = aws_iam_role.worker_node_role.name
}

# EKS Cluster Creation
resource "aws_eks_cluster" "eks_cluster" {
  name     = "my_eks_cluster"
  role_arn = aws_iam_role.cluster_role.arn
  version = var.eks_version

  vpc_config {
    subnet_ids = concat(
      values(aws_subnet.private_subnets)[*].id,
      values(aws_subnet.public_subnets)[*].id
    )
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_role_policy_attach
  ]
  tags = var.tags
}

resource "aws_eks_node_group" "Node_group" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks_node_group"
  node_role_arn = aws_iam_role.worker_node_role.arn
  subnet_ids = values(aws_subnet.private_subnets)[*].id

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = var.max_unavailable
  }

  ami_type = var.ami_type
  instance_types = var.instance_type
  capacity_type = var.capacity_type

  depends_on = [
    aws_iam_role_policy_attachment.CNI_policy_attachment,
    aws_iam_role_policy_attachment.worker_node_role_policy_attach,
    aws_iam_role_policy_attachment.EC2CR_policy_attachment,
    aws_iam_role_policy_attachment.EKSAutoScaling_policy_attachment
  ]

  tags = var.tags
}
