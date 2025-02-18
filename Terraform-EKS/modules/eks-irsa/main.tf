resource "aws_iam_role" "this"{
    name = var.iam_role_name
    description = var.iam_role_description
    path = var.iam_role_path
    assume_role_policy = data.aws_iam_policy_document.trust_relationship.json
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = length(var.iam_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = element(var.iam_policy_arns, count.index)
}