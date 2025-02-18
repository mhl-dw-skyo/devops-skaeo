data "aws_eks_cluster_auth" "cluster" {
  name = local.eks_cluster_name
}


data "aws_eks_cluster" "eks" {
  name = local.eks_cluster_name
}