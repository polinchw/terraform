variable "host" {
}

variable "client_certificate" {
}

variable "client_key" {
}

variable "cluster_ca_certificate" {
}

variable "git_token" {
    description = "The token to the git_repo."
}
variable "git_repo" {
    description = "The git repo that contains the argocd autopilot boot strap."
}

variable "kubeconfig_file" {
    description = "The location of the kubeconfig file."
}