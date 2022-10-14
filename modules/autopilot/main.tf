provider "kubectl" {
    load_config_file       = true
    config_path = "~/.kube/config"
    host = var.host
}
resource "null_resource" "install_autopilot" {

  provisioner "local-exec" {
    command     = "./modules/autopilot/install_autopilot.sh ${git_token} ${git_repo}"
    interpreter = ["/bin/bash", "-c"]
  }
}