resource "aws_iam_role" "karpenter_node_role" {
  name                 = "KarpenterNodeRole-${local.eks_cluster_name}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  force_detach_policies = false
  max_session_duration = 3600
  path                 = "/"

  tags = {
    "Name" = "KarpenterNodeRole-${local.eks_cluster_name}"
  }
}

resource "aws_iam_role_policy_attachment" "karpenter_ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.karpenter_node_role.name
}

resource "aws_iam_role_policy_attachment" "karpenter_ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.karpenter_node_role.name
}

resource "aws_iam_role_policy_attachment" "karpenter_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.karpenter_node_role.name
}

resource "aws_iam_role_policy_attachment" "karpenter_eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.karpenter_node_role.name
}

resource "aws_iam_role_policy" "karpenter_node_custom_policy" {
  name   = "karpenter-node-custom-policy"
  role   = aws_iam_role.karpenter_node_role.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:RunInstances",
          "ec2:CreateTags",
          "iam:PassRole",
          "ec2:TerminateInstances",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeAvailabilityZones",
          "ssm:GetParameter"
        ]
        Resource = "*"
      }
    ]
  })
}



resource "aws_iam_instance_profile" "karpenter_node_profile" {
  name = "KarpenterNodeInstanceProfile-${local.eks_cluster_name}"
  role = aws_iam_role.karpenter_node_role.name
}


resource "aws_iam_policy" "karpenter_controller_policy" {
  name = "KarpenterControllerPolicy-${local.eks_cluster_name}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter",
          "ec2:DescribeImages",
          "ec2:RunInstances",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:TerminateInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeAvailabilityZones",
          "ec2:DeleteLaunchTemplate",
          "ec2:CreateTags",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:DescribeSpotPriceHistory",
          "pricing:GetProducts"
        ]
        Effect   = "Allow"
        Resource = "*"
        Sid      = "Karpenter"
      },
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = aws_iam_role.karpenter_node_role.arn
        Sid      = "PassNodeIAMRole"
      },
      {
        Effect   = "Allow"
        Action   = "eks:DescribeCluster"
        Resource = "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:cluster/${local.eks_cluster_name}"
        Sid      = "EKSClusterEndpointLookup"
      },
      {
        Sid      = "AllowScopedInstanceProfileCreationActions"
        Effect   = "Allow"
        Resource = "*"
        Action   = [
          "iam:CreateInstanceProfile"
        ]
        Condition = {
          StringEquals = {
            "aws:RequestTag/kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
            "aws:RequestTag/topology.kubernetes.io/region"         = "${data.aws_region.current.name}"
          }
          StringLike = {
            "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" = "*"
          }
        }
      },
      {
        Sid      = "AllowScopedInstanceProfileTagActions"
        Effect   = "Allow"
        Resource = "*"
        Action   = [
          "iam:TagInstanceProfile"
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceTag/kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
            "aws:ResourceTag/topology.kubernetes.io/region"         = "${data.aws_region.current.name}"
            "aws:RequestTag/kubernetes.io/cluster/${local.eks_cluster_name}"  = "owned"
            "aws:RequestTag/topology.kubernetes.io/region"          = "${data.aws_region.current.name}"
          }
          StringLike = {
            "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
            "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"  = "*"
          }
        }
      },
      {
        Sid      = "AllowScopedInstanceProfileActions"
        Effect   = "Allow"
        Resource = "*"
        Action   = [
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:DeleteInstanceProfile"
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceTag/kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
            "aws:ResourceTag/topology.kubernetes.io/region"         = "${data.aws_region.current.name}"
          }
          StringLike = {
            "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
          }
        }
      },
      {
        Sid      = "AllowInstanceProfileReadActions"
        Effect   = "Allow"
        Resource = "*"
        Action   = "iam:GetInstanceProfile"
      }
    ]
  })

}


module "eks_irsa_karpenter_controller" {
    source = "../eks-irsa"
    cluster_name = local.eks_cluster_name
    iam_role_name = "KarpenterControllerRole-${local.eks_cluster_name}"
    iam_role_description = "IRSA for KarpenterController"
    iam_policy_arns = [
        "arn:aws:iam::${data.aws_caller_identity.current.id}:policy/KarpenterControllerPolicy-${local.eks_cluster_name}"
    ]
    service_account_namespace = "kube-system"
    service_account_name = "karpenter"
    depends_on = [aws_iam_policy.karpenter_controller_policy,aws_iam_role.karpenter_node_role]
}


