terraform {
  backend "s3" {
    bucket  = "skaeo-tfstate-file-eu"
    key     = "stage-eu/infra/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}