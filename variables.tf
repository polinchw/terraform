variable "serviceprinciple_id" {
}

variable "serviceprinciple_key" {
}

variable "tenant_id" {
}

variable "subscription_id" {
}


variable "ssh_key" {
}

variable "location" {
  default = "eastus"
}

variable "kubernetes_version" {
    default = "1.23.8"
}

variable "git_token" {
  description = "Git token for interacting with Git"
  type = string
  default = "xxx"
}

variable "git_repo" {
  description = "The git repo that ArgoCD will bootstrap."
  type = string
  default = "https://github.com/polinchw/auto-pilot"
}

