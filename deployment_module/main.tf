data "aws_eks_cluster" "eks_cluster" {
  name = "my_eks_cluster"
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = data.aws_eks_cluster.eks_cluster.name
}

resource "kubernetes_namespace" "deployment_namespace" {
  metadata {
    name = "deployment"
  }
}

resource "kubernetes_manifest" "deployment_manifest" {
  manifest = yamldecode(file("${path.module}/../manifests/deployment.yaml"))
}

resource "kubernetes_manifest" "deployment_service_manifest" {
  manifest = yamldecode(file("${path.module}/../manifests/deployment_service.yaml"))
}
