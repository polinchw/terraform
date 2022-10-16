
provider "kubectl" {
    load_config_file       = true
    config_path = "~/.kube/config"
    host = var.host
}

provider "kubernetes" {
    host                   =  var.host
    client_certificate     =  var.client_certificate
    client_key             =  var.client_key
    cluster_ca_certificate =  var.cluster_ca_certificate
}


resource "kubernetes_deployment" "example" {
  metadata {
    name = "terraform-example"
    labels = {
      test = "MyExampleApp"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        test = "MyExampleApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "MyExampleApp"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "example"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          # liveness_probe {
          #   http_get {
          #     path = "/nginx_status"
          #     port = 80

          #     http_header {
          #       name  = "X-Custom-Header"
          #       value = "Awesome"
          #     }
          #   }

          #   initial_delay_seconds = 3
          #   period_seconds        = 3
          # }
        }
      }
    }
  }
}

resource "kubernetes_service" "example" {
  metadata {
    name = "terraform-example"
  }
  spec {
    selector = {
      test = "MyExampleApp"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

resource "null_resource" "set_git_token" {
  provisioner "local-exec" {
    command = "export GIT_TOKEN=${var.git_token}"
  }
}

resource "null_resource" "set_git_repo" {
  provisioner "local-exec" {
    command = "export GIT_REPO=${var.git_repo}"
  }
}


resource "null_resource" "bootstrap_autopilot" {
  provisioner "local-exec" {
    command = "export GIT_TOKEN=${var.git_token} && export GIT_REPO=${var.git_repo} && ./argocd-autopilot-linux-amd64 repo bootstrap --recover"
  }
}