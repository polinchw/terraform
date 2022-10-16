#!/bin/bash
echo "Boot strap ArgoCD Autopilot..."
echo $1 > ~/.kube/aks-getting-started.conf

export KUBECONFIG=~/.kube/aks-getting-started.conf

export GIT_TOKEN=$2
export GIT_REPO=$3

./argocd-autopilot-linux-amd64 repo bootstrap --recover