data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name" 
    values = ["skaeo-${var.env}-vpc"]  
  }
}