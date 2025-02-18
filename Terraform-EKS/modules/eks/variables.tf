variable "env" {
   type = string
}

variable "eks_kub_version" {
  type = string
}

variable "public_sub_ids" {
  type = list(string)
}

variable "private_sub_ids" {
  type = list(string)
}

variable "key_name_eks" {
   type = string
}

variable "default_node_group" {
  type = object({ 
    name           =  string 
    desired_size   =  number
    max_size       =  number
    min_size       =  number     
    ami_type       =  string
    capacity_type  =  string
    disk_size      =  number
    instance_types =  list(string)
    labels         =  map(any)
  })  
}


variable "cluster_addon_map"{
  type            = map(any)
  description     = "Addon name and version"
  default         = {
    "coredns"                   = "v1.11.4-eksbuild.2"
    "aws-ebs-csi-driver"        = "v1.39.0-eksbuild.1"
    "aws-efs-csi-driver"        = "v2.1.4-eksbuild.1"
    "kube-proxy"                = "v1.30.9-eksbuild.3"
    "vpc-cni"                   = "v1.19.2-eksbuild.5"
    "eks-node-monitoring-agent" =  "v1.0.2-eksbuild.2" 
  }
}


variable "cluster_access_iamuser" {
  type = map(string)
  description = "Access for Iam users"
}

variable "cluster_access_iamrole" {
  type = map(string)
  description = "Access for Iam roles"
}


variable "endpoint_private_access" {
  type = bool
  
}

variable "endpoint_public_access" {
  type = bool
}

variable "additional_security_group_ids" {
  type = list(string)
  default = []
}

variable "public_acccess_cidrs" {
  type    = list(string)
  default =["0.0.0.0/0"]
}


variable "sg_ingress_rules" {
    type        = map(object(
      {
        from = number
        to = number
        proto = string
        cidr = string
        desc = string
      }
    ))
}


variable "sg_ingress_rules_source" {
    type        = map(object(
      {
        from = number
        to = number
        proto = string
        source_security_group_id = string
        desc = string
      }
    ))

    default = {}
}


variable "sg_egress_rules" {
    type        = map(object(
      {
        from = number
        to = number
        proto = string
        cidr = string
        desc = string
      }
    ))
}


variable "sg_egress_rules_source" {
    type        = map(object(
      {
        from = number
        to = number
        proto = string
        source_security_group_id = string
        desc = string
      }
    ))

    default = {}
}

