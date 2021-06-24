# AKS and Terraform

This repository shows examples and guides for using [Terraform](https://terraform.io) to provision a [AKS (Azure Kubernetes Service) Cluster](https://azure.microsoft.com/en-gb/services/kubernetes-service/) on Azure

## Instructions

### Pre-requisites

Leading on from session 3 this repository provides instruction for both provisioning your cluster, pushing docker images to your own container registry and adopting a GitOps workflow using ArgoCD

### Step 1 - Switch to the session 4 branch

If you haven't already done so you'll need to switch to the session 4 branch of this repository.

Once you have navigated to the **devops-upskill-aks-terraform** repository you can switch branches by running:

```
git checkout session-004-gitops
```

### Step 2 - Provision your cluster

You have probably destroyed your Kubernetes cluster following the previous session. 

Follow through the [Provisioning](./docs/PROVISIONING.md) guide to re-provision your Kubernetes cluster.

The Terraform files have also been updated to include the creation of a container registry.

For those interested in the terraform changes, you can see a diff of what has changed since session 3 here:

[https://github.com/techreturners/devops-upskill-aks-terraform/compare/session-004-gitops](https://github.com/techreturners/devops-upskill-aks-terraform/compare/session-004-gitops)

### Step 3 - Build and push your docker image

The next step is to build the docker image locally and push it up to your newly created container registry.

Follow through the [Pushing Image Guide](./docs/PUSHINGIMAGE.md) for instructions on how to do this.

### Step 4 - Deploy and navigate to ArgoCD

Now you can move on to getting the backend API Python app deployed via Argo.

Follow through the [Argo setup and configuration steps](./docs/ARGO.md)

### Step 5 - Setting up your DevOps workflow in Argo

Great work! If you've got to here you should now be able to see the Argo Dashboard.

All your infrastructure is setup ready to go! Now you can head over to the GitOps repository to setup your workflow.

[https://github.com/techreturners/devops-upskill-gitops](https://github.com/techreturners/devops-upskill-gitops)

### FAQs

You can find the FAQs [here](./docs/FAQS.md).
