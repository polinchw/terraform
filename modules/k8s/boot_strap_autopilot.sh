#!/bin/bash
echo "Boot strap ArgoCD Autopilot..."

export KUBECONFIG=./aks-getting-started-config

export GIT_TOKEN=$1
export GIT_REPO=$2

./argocd-autopilot-linux-amd64 repo bootstrap --recover