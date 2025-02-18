locals {
  eks_cluster_addon_map = {
    "1.32" = {
      "coredns"                   = "v1.11.4-eksbuild.2"
      "aws-ebs-csi-driver"        = "v1.39.0-eksbuild.1"
      "aws-efs-csi-driver"        = "v2.1.4-eksbuild.1"
      "kube-proxy"                = "v1.30.9-eksbuild.3"
      "vpc-cni"                   = "v1.19.2-eksbuild.5"
      "eks-node-monitoring-agent" = "v1.0.2-eksbuild.2"
    }
  }

  eks_cluster_name = "${var.env}-eks-cluster"
}