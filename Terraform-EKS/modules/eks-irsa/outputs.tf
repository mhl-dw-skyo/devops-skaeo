output "arn" {
    value = join("", aws_iam_role.this.*.arn)
    description = "ARN of specified role"
}