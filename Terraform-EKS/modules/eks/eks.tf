# create key pair
resource "tls_private_key" "ec2_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "aws_ec2_private_key" {
  key_name   = var.key_name_eks
  public_key = tls_private_key.ec2_private_key.public_key_openssh
}


locals {
  pub_pri_subnet_ids_list       = concat(var.public_sub_ids, var.private_sub_ids)
}


resource "aws_eks_cluster" "eks" {
  name                          = local.eks_cluster_name
  role_arn                      = aws_iam_role.eks_cluster.arn
  version                       = var.eks_kub_version
  vpc_config {
    endpoint_private_access     = var.endpoint_private_access
    endpoint_public_access      = var.endpoint_public_access
    public_access_cidrs        = var.public_acccess_cidrs
    security_group_ids          = concat([aws_security_group.cluster.id], var.additional_security_group_ids, )
    subnet_ids                  = var.private_sub_ids 

  }
    access_config {
        authentication_mode = "API"
        bootstrap_cluster_creator_admin_permissions = false 
    }
    tags = {
      "karpenter.sh/discovery"  = local.eks_cluster_name
      "alpha.eksctl.io/cluster-oidc-enabled" = "true"
   }

  depends_on  = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
  ]
}


resource "aws_iam_openid_connect_provider" "this" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
  client_id_list = ["sts.amazonaws.com"]
}

resource "aws_eks_node_group" "default_node_group" {
  cluster_name                = aws_eks_cluster.eks.name
  node_group_name             = var.default_node_group.name
  node_role_arn               = aws_iam_role.node_group.arn
  subnet_ids                  =  var.private_sub_ids                    # VPC PRIVATE SUBNET ID LIST
  version                     =  var.eks_kub_version                    # Kubernetes version
  # Configuration block with scaling settings
  
  scaling_config {
    desired_size              = var.default_node_group.desired_size
    max_size                  = var.default_node_group.max_size         # Maximum number of worker nodes.
    min_size                  = var.default_node_group.min_size         # Minimum number of node_group of worker nodes.
  }
  remote_access {
    ec2_ssh_key =  var.key_name_eks
  }
  ami_type                    = var.default_node_group.ami_type
  capacity_type               = var.default_node_group.capacity_type    # Valid values: ON_DEMAND, SPOT
  disk_size                   = var.default_node_group.disk_size        # Disk size in GiB for worker nodes
  # Force version update if existing pods are unable to be drained due to a pod disruption budget issue.
  force_update_version        = false
  instance_types              = var.default_node_group.instance_types   # List of instance types associated with the EKS Node Group
  labels                      = var.default_node_group.labels
   

  tags = {
      env  = var.env
      Name = var.default_node_group.name
  }

  update_config{
    max_unavailable_percentage = "25"
  }

  node_repair_config {
    enabled = "true"
  }

  depends_on = [
      aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
      aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
      aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,

  ]
}
