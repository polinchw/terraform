terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.5.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.serviceprinciple_id
  client_secret   = var.serviceprinciple_key
  tenant_id       = var.tenant_id

  features {}
}

module "install_autopilot" {
  source                = "github.com/polinchw/argocd-autopilot-terraform-modules//modules/install-autopilot"
}

module "cluster" {
  source                = "./modules/cluster/"
  serviceprinciple_id   = var.serviceprinciple_id
  serviceprinciple_key  = var.serviceprinciple_key
  ssh_key               = var.ssh_key
  location              = var.location
  kubernetes_version    = var.kubernetes_version
  kubeconfig_file       = "aks-getting-started-config"
}

module "boostrap_argocd_autopilot" {
  source          = "github.com/polinchw/argocd-autopilot-terraform-modules//modules/bootstrap-autopilot"
  kubeconfig_file = "modules/cluster/aks-getting-started-config"
  git_token       = var.git_token
  git_repo        = var.git_repo
  cluster_name    = module.cluster.host
}
