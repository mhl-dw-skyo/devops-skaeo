
## Access entry for Iam users
resource "aws_eks_access_entry" "eks_cluster_access_user" {
  for_each          = var.cluster_access_iamuser
  cluster_name      = aws_eks_cluster.eks.name
  principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/${each.key}"
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_cluster_access_user_policy_association" {
  for_each      = var.cluster_access_iamuser
  cluster_name  = aws_eks_cluster.eks.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/${each.value}"
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/${each.key}"

  access_scope {
    type       = "cluster"
  }
}


### Access entry for Iam Roles 

resource "aws_eks_access_entry" "eks_cluster_access_role" {
  for_each          = var.cluster_access_iamrole
  cluster_name      = aws_eks_cluster.eks.name
  principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.id}:role/${each.key}"
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_cluster_access_role_policy_association" {
  for_each      = var.cluster_access_iamrole
  cluster_name  = aws_eks_cluster.eks.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/${each.value}"
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.id}:role/${each.key}"

  access_scope {
    type       = "cluster"
  }
}