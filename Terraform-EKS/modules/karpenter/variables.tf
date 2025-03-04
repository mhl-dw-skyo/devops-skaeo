variable "env" {
   type = string
}

variable "enable_karpenter" {
  type    = bool
}

variable "nodepool_configs" {
  type = map(object({
    name          = string
    taint         = map(string)
    instance_types_karpenter = list(string)
    capacity_type  = list(string)
    arch          = list(string)
    
  }))

}