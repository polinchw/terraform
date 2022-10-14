variable "host" {
}

variable "client_certificate" {
}

variable "client_key" {
}

variable "cluster_ca_certificate" {
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