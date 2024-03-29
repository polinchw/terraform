# Terraform

## Description

This repo has Terraform manifests that will deploy:

+ AKS Cluster
+ ArgoCD via AutoPilot (this is done with my [argocd-autopilot-terraform-modules](https://github.com/polinchw/argocd-autopilot-terraform-modules))

This Terraform example came from Marcel Demper's [Github](https://github.com/marcel-dempers/docker-development-youtube-series) repo.  Watch his [video](https://www.youtube.com/watch?v=bHjS4xqwc9A) on the 
subject to make the tutorial easier to follow.

More resources:

Terraform provider for Azure [here](https://github.com/terraform-providers/terraform-provider-azurerm) <br/>

Another Terraform instructional [video](https://www.youtube.com/watch?v=7xngnjfIlK4)

## Azure CLI

You can get the Azure CLI on [Docker-Hub](https://hub.docker.com/_/microsoft-azure-cli) <br/>
We'll need the Azure CLI to gather information so we can build our Terraform file.

```
# Run Azure CLI
docker run -it --rm -v ${PWD}:/work -w /work --entrypoint /bin/sh mcr.microsoft.com/azure-cli:2.30.0

```

## Login to Azure

```
#login and follow prompts
az login 
TENANT_ID=<your-tenant-id>

# view and select your subscription account

az account list -o table
SUBSCRIPTION=<id>
az account set --subscription $SUBSCRIPTION

```


## Create Service Principal

Kubernetes needs a service account to manage our Kubernetes cluster </br>
Lets create one! </br>

```

SERVICE_PRINCIPAL_JSON=$(az ad sp create-for-rbac --skip-assignment --name aks-getting-started-sp -o json)

# Keep the `appId` and `password` for later use!

SERVICE_PRINCIPAL=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.appId')
SERVICE_PRINCIPAL_SECRET=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.password')

#note: reset the credential if you have any sinlge or double quote on password
az ad sp credential reset --name "aks-getting-started-sp"

# Grant contributor role over the subscription to our service principal

az role assignment create --assignee $SERVICE_PRINCIPAL \
--scope "/subscriptions/$SUBSCRIPTION" \
--role Contributor

```
For extra reference you can also take a look at the Microsoft Docs: [here](https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/aks/kubernetes-service-principal.md) </br>


# Terraform CLI
```
# Get Terraform

curl -o /tmp/terraform.zip -LO https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip

unzip /tmp/terraform.zip
chmod +x terraform && mv terraform /usr/local/bin/

cd kubernetes/cloud/azure/terraform/

```

# Generate SSH key

```
ssh-keygen -t rsa -b 4096 -N "VeryStrongSecret123!" -C "your_email@example.com" -q -f  ~/.ssh/id_rsa
SSH_KEY=$(cat ~/.ssh/id_rsa.pub)
```

## Create AKS cluster with Terraform and Autopilot

Terrform will do the following:

+ Create a Kubernetes cluster on Azure.  

+ Install ArgoCD Autopilot and bootstrap a git repo that contains some basic helm charts. 
  
+ The following example uses my ArgoCD [autopilot](https://github.com/polinchw/auto-pilot/) repo as an example.
You'll need to set your `git_token` and `git_repo` to the 
repo that contains your ArgoCD Autopilot repo.

+ Documentation on all the Kubernetes fields for terraform [here](https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html)
```
terraform init

terraform plan -var serviceprinciple_id=$SERVICE_PRINCIPAL \
  -var name=aks-getting-started \
  -var serviceprinciple_key="$SERVICE_PRINCIPAL_SECRET" \
  -var tenant_id=$TENANT_ID \
  -var subscription_id=$SUBSCRIPTION \
  -var ssh_key="$SSH_KEY" \
  -var git_token=$GIT_TOKEN \
  -var git_repo=https://github.com/polinchw/auto-pilot \
  -var git_username=polinchw

terraform apply -var serviceprinciple_id=$SERVICE_PRINCIPAL \
  -var name=aks-getting-started \
  -var serviceprinciple_key="$SERVICE_PRINCIPAL_SECRET" \
  -var tenant_id=$TENANT_ID \ 
  -var subscription_id=$SUBSCRIPTION \ 
  -var ssh_key="$SSH_KEY" \   
  -var git_token=$GIT_TOKEN \  
  -var git_repo=https://github.com/polinchw/auto-pilot \ 
  -var git_username=polinchw
```

### Let's see what we deployed

```
# grab our AKS config
az aks get-credentials -n aks-getting-started -g aks-getting-started

kubectl get svc
```
### Clean up

#### Remove the Argocd namespace

You want to remove the argocd namespace from the Terraform state before you destroy the cluster because it can 
have a Kubernetes finalizer that can cause the larger destory to hang.

```
terraform state rm module.k8s.kubernetes_namespace.argocd
```

#### Destroy the cluster with Terraform

```
terraform destroy -var serviceprinciple_id=$SERVICE_PRINCIPAL \
  -var name=aks-getting-started \
  -var serviceprinciple_key="$SERVICE_PRINCIPAL_SECRET" \
  -var tenant_id=$TENANT_ID \ 
  -var subscription_id=$SUBSCRIPTION \ 
  -var ssh_key="$SSH_KEY" \   
  -var git_token=$GIT_TOKEN \  
  -var git_repo=https://github.com/polinchw/auto-pilot \ 
  -var git_username=polinchw
```

#### Delete Resource Group AZ CLI

To delete the resource group with the az cli:

```
az group delete --name aks-getting-started
```

#### Manual Custer Upgrade

##### Control Plane

To upgrade the AKS control plane run this command:

```
az aks upgrade --kubernetes-version 1.24.10 --name upgrade --resource-group upgrade-rg --control-plane-only
```

##### Upgrade Node Pool

To upgrade the AKS node pool run this command:

```
az aks nodepool upgrade --cluster-name upgrade --nodepool-name agentpool --resource-group upgrade-rg --kubernetes-version 1.24.10
```
