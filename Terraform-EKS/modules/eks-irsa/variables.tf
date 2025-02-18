variable "cluster_name"{
    type = string
    description = "Cluster Name"
}

variable "service_account_namespace"{
    type = string
    description = "Iam role to be created for service account"
}
variable "service_account_name"{
    type = string
    description = "Service account name "
}

variable "iam_role_name"{
    type = string
    description = "Iam role added to serviceaccount"
}

variable "iam_role_description"{
    type = string
    default = ""
    description = "Iam role added to serviceaccount"
}
variable "iam_role_path"{
    type = string
    default = "/"
    description = "Path of the Iam role to be created for eks service account"
}

variable "iam_policy_arns"{
    type = list(string)
    default = []
    description = "Iam policy arns to attach to role"
}

