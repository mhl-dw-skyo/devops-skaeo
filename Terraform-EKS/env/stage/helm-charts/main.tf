

module "karpenter" {
  source                   = "../../../modules/karpenter"
  env                      = var.env
  instance_types_karpenter = var.instance_types_karpenter
  enable_karpenter         = var.enable_karpenter
}









