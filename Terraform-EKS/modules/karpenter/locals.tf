locals {
    eks_cluster_name      = "${var.env}-eks-cluster"
    common_nodepool_name  = "${local.eks_cluster_name}-common-nodepool"
    common_nodeclass_name = "${local.eks_cluster_name}-common-nodeclass"
}