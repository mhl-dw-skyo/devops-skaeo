locals {
    eks_cluster_name= "${var.env}-eks-cluster"
    tags = {
        Environment = var.env
        "karpenter.sh/discovery"  = "${local.eks_cluster_name}"
    }
    sg-tags = {
        Name = "${local.eks_cluster_name}-security-group"
    }
    
}