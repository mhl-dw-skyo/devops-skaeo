module "eks_irsa_cni"{
    source = "../eks-irsa"
    cluster_name = aws_eks_cluster.eks.name
    iam_role_name = "${aws_eks_cluster.eks.name}-cni-role"
    iam_role_description = "IRSA for EKS CNI Plugin"
    iam_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    ]
    service_account_namespace = "kube-system"
    service_account_name = "aws-node"
    depends_on = [aws_eks_cluster.eks]
}

module "eks_irsa_ebs_csi"{
    source = "../eks-irsa"
    cluster_name = aws_eks_cluster.eks.name
    iam_role_name = "${aws_eks_cluster.eks.name}-ebs-csi-role"
    iam_role_description = "IRSA for EBS CSI Driver"
    iam_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    ]
    service_account_namespace = "kube-system"
    service_account_name = "ebs-csi-controller-sa"
    depends_on = [aws_eks_cluster.eks]
}

module "eks_irsa_efs_csi"{
    source = "../eks-irsa"
    cluster_name = aws_eks_cluster.eks.name
    iam_role_name = "${aws_eks_cluster.eks.name}-efs-csi-role"
    iam_role_description = "IRSA for EFS csi driver"
    iam_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
    ]
    service_account_namespace = "kube-system"
    service_account_name = "efs-csi-controller-sa"
    depends_on = [aws_eks_cluster.eks]
}

