
provider "kubernetes" {
    host                   =  var.host
    client_certificate     =  var.client_certificate
    client_key             =  var.client_key
    cluster_ca_certificate =  var.cluster_ca_certificate
}

resource "kubernetes_secret" "git_creds" {
  metadata {
    name = "git-creds"
    namespace = "argocd"
  }

  data = {
    username = var.git_username
    password = var.git_token
  }

}