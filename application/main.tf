data "aws_eks_cluster" "eks_cluster" {
  name = "my_eks_cluster"
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = data.aws_eks_cluster.eks_cluster.name
}

data "aws_vpc" "eks_vpc" {
  id = data.aws_eks_cluster.eks_cluster.vpc_config[0].vpc_id
}

data "aws_subnets" "alb_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }

  tags = {
    name = "eks_cluster"
    alb = "true"
  }
}


resource "kubernetes_namespace" "deployment_namespace" {
  metadata {
    name = "deployment"
  }
}

resource "kubernetes_manifest" "deployment_manifest" {
  manifest = yamldecode(file("${path.module}/../manifests/deployment.yaml"))
  depends_on = [ helm_release.aws_load_balancer_controller ]
}


data "template_file" "deployment_service" {
  template = file("${path.module}/../manifests/deployment_service.yaml")

  # vars = {
  #   subnet_ids = data.aws_subnets.alb_subnet.ids[0]
  # }
  
}

resource "kubernetes_manifest" "deployment_service_manifest" {
  manifest = yamldecode(data.template_file.deployment_service.rendered)
  depends_on = [helm_release.aws_load_balancer_controller]
}

# resource "helm_release" "aws_load_balancer_controller" {
#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"

#   set {
#     name  = "clusterName"
#     value = data.aws_eks_cluster.eks_cluster.name
#   }
# }