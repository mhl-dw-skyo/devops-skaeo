# Create ECR repositories
resource "aws_ecr_repository" "ecr_repos" {
  for_each = toset(var.ecr_repo_names)

  name = each.key  

  image_tag_mutability = "MUTABLE" 
}