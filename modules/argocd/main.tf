
provider "helm" {
    kubernetes {
    config_path = "~/.kube/config"
    host = var.host
    client_certificate = var.client_certificate
    cluster_ca_certificate = var.cluster_ca_certificate
    client_key = var.client_key
    }
}

provider "kubectl" {
    load_config_file       = true
    config_path = "~/.kube/config"
    host = var.host
}

module "argocd" {
    source  = "DeimosCloud/argocd/kubernetes"
    version = "1.1.2"
    image_tag = "v2.4.14"
    chart_version = "5.5.25"
    ingress_host = "argocd.example.com"
}