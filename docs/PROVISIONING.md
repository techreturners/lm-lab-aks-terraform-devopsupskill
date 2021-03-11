# AKS and Terraform

The steps here cover how to provision your AKS cluster and container registry.

## Instructions

**NOTE:** You might have already performed some of the steps (such as installing tools) mentioned below. If so you can ignore those steps and move directly to **Step 4**

### Step 1 - Install and configure the Azure CLI

We'll use the Azure CLI to get information from the cluster.

To install this you can install manually by following [these instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) or if you have a package manager you can use the instructions below:

**Homebrew**

```
brew install azure-cli
```

**Chocolatey**

```
choco install azure-cli
```

Once it is installed we need to ensure that the CLI is logged in - to do this run:

```
az login
```

### Step 2 - Install kubectl tool

The `kubectl` tool will be utilised to interact with your Kubernetes (K8S) cluster.

You can install this manually by following this guide below:

https://kubernetes.io/docs/tasks/tools/install-kubectl/

Or alternatively if you use a package manager it can be installed using the package manager:

**Homebrew**

```
brew install kubernetes-cli
```

**Chocolatey**

```
choco install kubernetes-cli
```

You can verify that it has installed correctly by running 

```
kubectl version
```

It should print something like the below:

```
Client Version: version.Info{Major:"1", Minor:"20", GitVersion:"v1.20.4", GitCommit:"e87da0bd6e03ec3fea7933c4b5263d151aafd07c", GitTreeState:"clean", BuildDate:"2021-02-21T20:21:49Z", GoVersion:"go1.15.8", Compiler:"gc", Platform:"darwin/amd64"}
```

Dont worry if it says "Unable to connect to server" at this stage. We'll be sorting that later.

### Step 3 - Explore the files

Before we go ahead and create your cluster its worth exploring the files.

Oh and before we do explore, the files in this directory could have been named whatever we like. For example the **outputs.tf** file can have been called **foo.tf** - we just chose to call it that because it contained outputs. So the naming was more of a standard than a requirement.

**terraform.tfvars**

Think of this as the place where you define the actual values of variables to be used by your terraform configuration.

**aks-cluster.tf** 

Does the actual job of provisioning the AKS cluster within an Azure resource group.

The default_node_pool defines the number of VMs and the VM type the cluster uses. The addon_profile enables the Kubernetes dashboard.

**outputs.tf**

This file defines the outputs that will be produced by terraform when things have been provisioned.

**versions.tf** 

Configures the terraform providers (in our case the Azure provider) and sets the Terraform version to at least 0.14.

### Step 4 - Create an Azure Service Principle

You'll need to authenticate with Azure.

We'll use the Active Directory service principal account.

Run the following command:

```
az ad sp create-for-rbac --skip-assignment
```

It should produce something similar to the following:

```
{
  "appId": "aaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaass",
  "displayName": "azure-cli-2021-02-25-21-53-21",
  "name": "http://azure-cli-2021-02-25-21-53-21",
  "password": "somepasswordherer",
  "tenant": "43fre290-c575-4ee5-8d85-6bf15b4b81f9"
}
```

### Step 5 - Update the tfvars file

Now you know the files and have your service principal details, the next step is to update the tfvars file according to your project.

Update the appId and password as per your service principal account.

### Step 6 - Initialise terraform

We need to get terraform to pull down the Azure provider.

In order to do this run:

```
terraform init
```

You should see something similar to the below:

```
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "2.48.0"...
- Installing hashicorp/azurerm v2.48.0...
- Installed hashicorp/azurerm v2.48.0 (signed by HashiCorp)
```

### Step 7 - Review changes with a plan

Firstly run a **plan** to see if what Terraform decides will happen.

```
terraform plan
```

### Step 8 - Create your cluster with apply

We can then create your cluster by applying the configuration.

```
terraform apply
```

Sit back and relax - it might take 10 mins or so to create your cluster.

Once its finished it'll output something like the info below. Those **outputs** are defined in the **outputs.tf** file.

```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

acr_registry_name = "devopsupskillregistryqK4Wj"
kubernetes_cluster_name = "devops-upskill-aks"
resource_group_name = "devops-upskill-rg"
```

Once its done you'll have a your Kubernetes cluster all ready to go!!!

**NOTE:** Make a note of the value for your **acr_registry_name** because you'll need that in a moment.

### Step 9 - Configure your **kube control** 

**kubectl** is used to issue actions on our cluster.

We need to configure **kubectl** to be able to authenticate with your cluster.

To do this we use the Azure Command Line to get the credentials. Notice how we reference the outputs in the command below:


```
az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)
```

It should say something like:

```
Merged "devops-upskill-aks" as current context in /Users/jamesheggs/.kube/config
```

Just hit 'y' if it asks you whether you wish to overwrite previous values.

### Step 10 - Check if kubectl can access cluster

You can now verify if `kubectl` can access your cluster.

Go ahead and see how many nodes are running:

```
kubectl get nodes
```

It should show something like:

```
NAME                              STATUS   ROLES   AGE     VERSION
aks-default-51320324-vmss000000   Ready    agent   4m41s   v1.18.14
aks-default-51320324-vmss000001   Ready    agent   3m57s   v1.18.14
```

Now you can head back over to the [README](../README.md) for the next stage which is pushing your docker images to your registry.
