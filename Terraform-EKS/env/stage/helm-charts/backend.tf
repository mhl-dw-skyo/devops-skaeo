terraform {
  backend "s3" {
    bucket  = "skaeo-tfstate-file-eu"
    key     = "stage-eu/helm/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}