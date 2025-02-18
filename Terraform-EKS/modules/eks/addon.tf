resource "aws_eks_addon" "coredns" {
  cluster_name                =  aws_eks_cluster.eks.name
  addon_name                  = "coredns"
  addon_version               = var.cluster_addon_map["coredns"]
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on = [
    aws_eks_cluster.eks, aws_eks_node_group.default_node_group
  ]

}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name                =  aws_eks_cluster.eks.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = var.cluster_addon_map["aws-ebs-csi-driver"]
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = "arn:aws:iam::${data.aws_caller_identity.current.id}:role/${aws_eks_cluster.eks.name}-ebs-csi-role"
  depends_on = [
    aws_eks_cluster.eks, aws_eks_node_group.default_node_group, module.eks_irsa_ebs_csi
  ]
}

resource "aws_eks_addon" "efs_csi" {
  cluster_name                =  aws_eks_cluster.eks.name
  addon_name                  = "aws-efs-csi-driver"
  addon_version               = var.cluster_addon_map["aws-efs-csi-driver"]
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = "arn:aws:iam::${data.aws_caller_identity.current.id}:role/${aws_eks_cluster.eks.name}-efs-csi-role"
  depends_on = [
    aws_eks_cluster.eks, aws_eks_node_group.default_node_group, module.eks_irsa_efs_csi
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                =  aws_eks_cluster.eks.name
  addon_name                  = "kube-proxy"
  addon_version               = var.cluster_addon_map["kube-proxy"]
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = "arn:aws:iam::${data.aws_caller_identity.current.id}:role/${aws_eks_cluster.eks.name}-cni-role"
  depends_on = [
    aws_eks_cluster.eks, aws_eks_node_group.default_node_group, module.eks_irsa_cni
  ]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                =  aws_eks_cluster.eks.name
  addon_name                  = "vpc-cni"
  addon_version               = var.cluster_addon_map["vpc-cni"]
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = "arn:aws:iam::${data.aws_caller_identity.current.id}:role/${aws_eks_cluster.eks.name}-cni-role"
  depends_on = [
    aws_eks_cluster.eks, aws_eks_node_group.default_node_group, module.eks_irsa_cni
  ]
}

resource "aws_eks_addon" "node_monitoring_agent" {
  cluster_name                =  aws_eks_cluster.eks.name
  addon_name                  = "eks-node-monitoring-agent"
  addon_version               = var.cluster_addon_map["eks-node-monitoring-agent"]
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on = [
    aws_eks_cluster.eks, aws_eks_node_group.default_node_group
  ]
}