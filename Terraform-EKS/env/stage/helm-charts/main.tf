

module "karpenter" {
  source                   = "../../../modules/karpenter"
  env                      = var.env
  enable_karpenter         = var.enable_karpenter
  nodepool_configs         = var.nodepool_configs
}

module "irsa" {
  source =  "../../../modules/irsa"
  env = var.env
}

module "storage-class" {
  source =  "../../../modules/storage-class"
}


module "ecr_repositories" {
  source = "../../../modules/ecr-repo"

  ecr_repo_names = var.ecr_repo_names
}







