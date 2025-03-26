resource "aws_iam_policy" "myrollcallproweb_policy" {
  name = "myrollcallproweb-${local.eks_cluster_name}-policy"
  description = "Policy for myrollcallproweb"
  path   = "/"
  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "sid0",
			"Effect": "Allow",
			"Action": [
				"secretsmanager:GetSecretValue",
				"secretsmanager:DescribeSecret"
			],
			"Resource": "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:secret:myrollcallpro-web*"
		},
		{
			"Sid": "sid1",
			"Effect": "Allow",
			"Action": "secretsmanager:ListSecrets",
			"Resource": "*"
		}
	]
    })
}
module "eks_irsa_webpro_controller" {
    source = "../eks-irsa"
    cluster_name = local.eks_cluster_name
    iam_role_name = "myrollcallproweb-${local.eks_cluster_name}"
    iam_role_description = "IRSA for myrollcallproweb"
    iam_policy_arns = [
        "arn:aws:iam::${data.aws_caller_identity.current.id}:policy/myrollcallproweb-${local.eks_cluster_name}-policy"
    ]
    service_account_namespace = "stage"
    service_account_name = "myrollcallpro-web-staging-service-account"
    depends_on = [aws_iam_policy.myrollcallproweb_policy]
}