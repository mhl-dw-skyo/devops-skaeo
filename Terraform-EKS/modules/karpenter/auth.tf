resource "aws_eks_access_entry" "eks_cluster_access_nodes" {
  cluster_name      = local.eks_cluster_name
  principal_arn     = aws_iam_role.karpenter_node_role.arn
  type              = "EC2_LINUX"
  depends_on = [
    aws_iam_role.karpenter_node_role
  ]
}