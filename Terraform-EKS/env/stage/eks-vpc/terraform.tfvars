env                  = "stage-eu"
aws_region           = "eu-central-1"
vpc_cidr             = "10.31.0.0/16"
az_list_name         = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
pub_subnet_cidr_list = ["10.31.1.0/24", "10.31.2.0/24", "10.31.3.0/24"]
pri_subnet_cidr_list = ["10.31.8.0/22", "10.31.12.0/22", "10.31.16.0/22"]

eks_kub_version = "1.32"
key_name_eks    = "skaeo-eks-stage"

endpoint_private_access = false
endpoint_public_access  = true
default_node_group = {
  name           = "default-node-group"
  ami_type       = "AL2_ARM_64"
  capacity_type  = "ON_DEMAND"
  desired_size   = 1
  disk_size      = 50
  instance_types = ["t4g.medium"]
  max_size       = 2
  min_size       = 1
  labels = {
    "group" = "default_node_group"
  }
}

cluster_access_iamrole = {
  "test" = "AmazonEKSClusterAdminPolicy",
  "ec2-build-role"  = "AmazonEKSClusterAdminPolicy"
}
cluster_access_iamuser = {
  "Vishwaja" = "AmazonEKSClusterAdminPolicy"
}

sg_ingress_rules = {
  "sg1" = { from = 0, to = 65535, proto = "TCP", cidr = "0.0.0.0/0", desc = "From anywhere" }
}


sg_egress_rules = {
  "sg4" = { from = 0, to = 65535, proto = "TCP", cidr = "0.0.0.0/0", desc = "From anywhere" }

}

