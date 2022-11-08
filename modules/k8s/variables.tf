variable "cluster_name" {
  
}

variable "host" {
}

variable "client_certificate" {
}

variable "client_key" {
}

variable "cluster_ca_certificate" {
}

variable "git_username" {
   description = "The username assoicated with the git_token."
}

variable "git_token" {
    description = "This token is used for ArgoCD Image updater to update git with new releases."
  
}
