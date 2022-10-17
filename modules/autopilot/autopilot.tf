provider "kubernetes" {
    host                   =  var.host
    client_certificate     =  var.client_certificate
    client_key             =  var.client_key
    cluster_ca_certificate =  var.cluster_ca_certificate
}
provider "kubectl" {
    load_config_file       = true
    config_path = "~/.kube/config"
    host = var.host
}
resource "null_resource" "install_autopilot" {
  provisioner "local-exec" {
    command     = "./modules/autopilot/install_autopilot.sh"
    interpreter = ["/bin/bash", "-c"]
  }
}