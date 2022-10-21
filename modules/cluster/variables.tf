variable "name" {
   description = "The name of the cluster."
   default = "aks-getting-started"
}
variable "serviceprinciple_id" {
}

variable "serviceprinciple_key" {
}

variable "location" {
  default = "eastus"
}

variable "kubernetes_version" {
    default = "1.23.8"
}

variable "ssh_key" {
}

variable "kubeconfig_file" {

}