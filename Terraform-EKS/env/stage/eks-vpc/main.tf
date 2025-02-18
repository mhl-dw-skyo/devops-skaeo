module "vpc" {
  source               = "../../../modules/vpc"
  aws_region           = var.aws_region
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  pub_subnet_cidr_list = var.pub_subnet_cidr_list
  pri_subnet_cidr_list = var.pri_subnet_cidr_list
  az_list_name         = var.az_list_name
}


module "eks" {
  source                  = "../../../modules/eks"
  env                     = var.env
  eks_kub_version         = var.eks_kub_version
  public_sub_ids          = module.vpc.public_sub_ids
  private_sub_ids         = module.vpc.private_sub_ids
  default_node_group      = var.default_node_group
  key_name_eks            = var.key_name_eks
  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access  = var.endpoint_public_access
  cluster_addon_map       = local.eks_cluster_addon_map[var.eks_kub_version]
  cluster_access_iamuser  = var.cluster_access_iamuser
  cluster_access_iamrole  = var.cluster_access_iamrole
  sg_ingress_rules        = var.sg_ingress_rules
  sg_egress_rules         = var.sg_egress_rules
  depends_on              = [module.vpc]

}



resource "local_file" "eks" {
  filename        = "${path.root}/ssh_keys/${var.env}-eks.pem"
  content         = module.eks.private_key
  file_permission = "0600"
}







