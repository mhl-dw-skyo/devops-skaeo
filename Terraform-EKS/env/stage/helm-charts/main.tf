

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







