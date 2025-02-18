variable "env" {
   type = string
}

variable "instance_types_karpenter" {
  description = "What are the instance types?"
  type        = list(string)
}

variable "enable_karpenter" {
  type    = bool
}