# AKS and Terraform

This repository shows examples and guides for using [Terraform](https://terraform.io) to provision a [AKS (Azure Kubernetes Service) Cluster](https://azure.microsoft.com/en-gb/services/kubernetes-service/) on Azure

## Instructions

### Pre-requisites

You will need to ensure that you have installed Azure command line interface (Azure CLI) - as mentioned in the pre-session assignments for DevOps up-skill session three.

### Step 1 - Fork and clone

Fork this repository into your own GitHub account and then clone (your forked version) down to your local machine.

### Step 2 - Install and configure the Azure CLI

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

### Step 3 - Install kubectl tool

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

### Step 4 - Explore the files

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

### Step 5 - Create an Azure Service Principle

You'll need to authenticate with Azure.

We'll use the Active Directory service principal account.

Run the following command to create the service principal.

```
az ad sp create-for-rbac --skip-assignment
```

It should produce something similar to the following:

(Also, it's worth saving these details somewhere securely, we'll make use of them later in these instructions and further on in the programme)

```
{
  "appId": "aaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaass",
  "displayName": "azure-cli-2021-02-25-21-53-21",
  "name": "http://azure-cli-2021-02-25-21-53-21",
  "password": "somepasswordherer",
  "tenant": "43fre290-c575-4ee5-8d85-6bf15b4b81f9"
}
```

### Step 6 - Update the tfvars file

Now you know the files and have your service principal details, the next step is to update the tfvars file according to your project.

Update the **appId** and **password** as per your service principal account.

**IMPORTANT NOTE:** Make sure you do NOT commit/push the files with your service principal details.

### Step 7 - Initialise terraform

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

### Step 8 - Review changes with a plan

Firstly run a **plan** to see if what Terraform decides will happen.

```
terraform plan
```

### Step 9 - Create your cluster with apply

We can then create your cluster by applying the configuration.

```
terraform apply
```

Sit back and relax - it might take 10 mins or so to create your cluster. Grab yourself a drink ☕️

Once its finished it'll output something like the info below. 

Those **outputs** are defined in the **outputs.tf** file.

```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

kubernetes_cluster_name = "devops-upskill-aks"
resource_group_name = "devops-upskill-rg"
```

Once its done you'll have a your Kubernetes cluster all ready to go!!!

### Step 10 - Configure your **kube control** 

**kubectl** is used to issue actions on our cluster.

We need to configure **kubectl** to be able to authenticate with your cluster.

To do this we use the Azure Command Line to get the credentials. Notice how we reference the outputs in the command below:


```
az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)
```

It should say something like:

```
Merged "devops-upskill-aks" as current context in /Users/someuser/.kube/config
```

### Step 11 - Check if kubectl can access cluster

You can now verify if `kubectl` can access your cluster.

Go ahead and see how many nodes are running:

```
kubectl get nodes
```

It should show something like:

```
NAME                              STATUS   ROLES   AGE     VERSION
aks-default-51320324-vmss000000   Ready    agent   4m41s   v1.21.9
aks-default-51320324-vmss000001   Ready    agent   3m57s   v1.21.9
```

Exciting eh!!! 🚀

### Step 12 - Deploying your first app in a pod!!

Finally lets get a container running on your cluster.

Firstly check if there are any running pods

```
kubectl get pods
```

It should probably say something like this:

```
No resources found in default namespace.
```

Lets deploy the nginx deployment.

```
kubectl apply -f kubernetes/nginx-deployment.yaml
```

Now lets see the pods

```
kubectl get pods
```

And it will show something like this:

```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-5cd5cdbcc4-b46m7   1/1     Running   0          14s
nginx-deployment-5cd5cdbcc4-knxss   1/1     Running   0          14s
nginx-deployment-5cd5cdbcc4-sqm2p   1/1     Running   0          14s
```

Actually you know what, I think 3 replicas is a bit overkill. Lets bring it down to 2 replicas.

Update the nginx-deployment.yaml file and change it down to 2 and save the file.

Then re-run your deployment.

```
kubectl apply -f kubernetes/nginx-deployment.yaml
```

Now lets see the pods

```
kubectl get pods
```

And you should see something like this:

```
NAME                                READY   STATUS        RESTARTS   AGE
nginx-deployment-5cd5cdbcc4-b46m7   1/1     Running       0          3m47s
nginx-deployment-5cd5cdbcc4-knxss   1/1     Running       0          3m47s
nginx-deployment-5cd5cdbcc4-sqm2p   0/1     Terminating   0          3m47s
```

### Step 13 - Exposing your webserver

Finally lets get that web server exposed to the internet with a **service**

We can do this by creating the service (which will sit in front of our pods) and the ingress point

Firstly create the service

```
kubectl apply -f kubernetes/nginx-service.yaml
```

Kubernetes will now create the required load balancer and create an external IP address.

Keep running the command below until you see an external IP address

```
kubectl get services
```

It should output something like this:

```
NAME               TYPE           CLUSTER-IP   EXTERNAL-IP      PORT(S)        AGE
kubernetes         ClusterIP      10.0.0.1     <none>           443/TCP        4m54s
nginx-web-server   LoadBalancer   10.0.94.47   51.143.235.215   80:32580/TCP   7s
```

### Step 14 - Marvel at your creation

After around 5 to 10 mins you should be able to hit the endpoint with your browser. Using the example above I would go to: http://51.143.235.215

**NOTE** It does take a few mins, for some time you might see a 404 page.

**NOTE** Remember to check Google classroom before tearing things down. There are a couple of screenshots you should submit as evidence of your success 🙌

### Step 15 - Tearing down your cluster

Finally we want to destroy our cluster.

Firstly let's remove the service and ingress

```
kubectl delete -f kubernetes/nginx-service.yaml
```

Then we can destroy the cluster in full.

```
terraform destroy
```
