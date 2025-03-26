resource "aws_iam_policy" "alb_controller_policy" {
  name = "ALBControllerPolicy-${local.eks_cluster_name}"
  description = "Policy for alb controller"
  path   = "/"
  policy = file("${path.module}/alb-policy.json")
}
module "eks_irsa_awsloadbalancer_controller" {
    source = "../eks-irsa"
    cluster_name = local.eks_cluster_name
    iam_role_name = "ALBControllerRole-${local.eks_cluster_name}"
    iam_role_description = "IRSA for ALBController"
    iam_policy_arns = [
        "arn:aws:iam::${data.aws_caller_identity.current.id}:policy/ALBControllerPolicy-${local.eks_cluster_name}"
    ]
    service_account_namespace = "kube-system"
    service_account_name = "aws-load-balancer-controller"
    depends_on = [aws_iam_policy.alb_controller_policy]
}