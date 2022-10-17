#!/bin/bash
echo "Installing autopilot..."
# get the latest version or change to a specific version
VERSION=$(curl --silent "https://api.github.com/repos/argoproj-labs/argocd-autopilot/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

# download and extract the binary
curl -L --output - https://github.com/argoproj-labs/argocd-autopilot/releases/download/$VERSION/argocd-autopilot-linux-amd64.tar.gz | tar zx

# check the installation
./argocd-autopilot-linux-amd64 version