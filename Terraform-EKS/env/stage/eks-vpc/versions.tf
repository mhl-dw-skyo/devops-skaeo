terraform {
  required_version = ">= 1.6.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.14.0, < 6.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.1"
    }

  }
}


