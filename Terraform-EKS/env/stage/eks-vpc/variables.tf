variable "aws_region" {
  type = string
}

variable "env" {
  type = string
}
variable "vpc_cidr" {
  type = string
}

variable "pub_subnet_cidr_list" {
  type = list(string)
}

variable "az_list_name" {
  type = list(string)
}

variable "pri_subnet_cidr_list" {
  type = list(string)
}


variable "eks_kub_version" {
  type = string
}


variable "key_name_eks" {
  type = string
}

variable "default_node_group" {
  type = object({
    name           = string
    desired_size   = number
    max_size       = number
    min_size       = number
    ami_type       = string
    capacity_type  = string
    disk_size      = number
    instance_types = list(string)
    labels         = map(any)
  })
}





variable "cluster_access_iamuser" {
  type        = map(string)
  description = "Access for Iam users"
}

variable "cluster_access_iamrole" {
  type        = map(string)
  description = "Access for Iam roles"
}


variable "endpoint_private_access" {
  type = bool

}

variable "endpoint_public_access" {
  type = bool
}

variable "sg_ingress_rules" {
  type = map(object(
    {
      from  = number
      to    = number
      proto = string
      cidr  = string
      desc  = string
    }
  ))
}


variable "sg_ingress_rules_source" {
  type = map(object(
    {
      from                     = number
      to                       = number
      proto                    = string
      source_security_group_id = string
      desc                     = string
    }
  ))
  default = {}
}


variable "sg_egress_rules" {
  type = map(object(
    {
      from  = number
      to    = number
      proto = string
      cidr  = string
      desc  = string
    }
  ))
}


variable "sg_egress_rules_source" {
  type = map(object(
    {
      from                     = number
      to                       = number
      proto                    = string
      source_security_group_id = string
      desc                     = string
    }
  ))
  default = {}
}

