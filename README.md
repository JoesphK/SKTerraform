# AWS infrastructure by Terraform

---  
- [Overview](#overview)  
- [Features](#features)  
- [Architecture design](#Architecture-design)    


---

##  Overview

This repository is the base work of deploying AWS resources using Terraform.  
It is highly customizable and modular, allowing you to convert your infrastructure to code, allowing you to deploy it anywhere.  

---  
## Features  

- **VPC** — Private and public subnets, Internet Gateway, and NAT Gateway  
- **IAM** — Roles, policies, and access control  
- **Security Groups** — Controlled network access between resources  
- **EC2** — Compute instances  
- **Auto Scaling Group (ASG)** — Dynamic instance scaling  
- **EKS** — Managed Kubernetes cluster  
- **Ansible** — Configuration management and application deployment

All modules are orchestrated by the **root `main.tf`**, which pulls in variables from `variables.tf` and `terraform.tfvars` and deploys the infrastructure to **AWS**.
All the blocks have their own varibles.tf and outputs.tf, which can be edited at will.

---

##  Architecture design

RESUME HERE

```mermaid
flowchart LR

    %% Input files
    TFVARS["terraform.tfvars<br>Actual variable values"]
    VARS["variables.tf<br>Variable definitions"]

    %% Root configuration
    ROOT["main.tf<br>Root module orchestrator"]

    %% Modules
    VPC["module.vpc<br>VPC, Subnets, NAT, IGW"]
    IAM["module.iam<br>Roles and Policies"]
    SG["module.security_groups<br>Network Security Groups"]
    EC2["module.ec2<br>Compute Instances"]
    ASG["module.autoscaling<br>Auto Scaling Groups"]
    EKS["module.eks<br>Kubernetes Cluster"]
    ANS["module.ansible<br>Configuration Management"]

    %% End target
    AWS[(AWS Cloud<br>Deployed Infrastructure)]

    %% Relationships
    TFVARS --> ROOT
    VARS --> ROOT

    ROOT --> VPC
    ROOT --> IAM
    ROOT --> SG
    ROOT --> EC2
    ROOT --> ASG
    ROOT --> EKS
    ROOT --> ANS

    %% Output to AWS
    ROOT --> AWS
```
---  
## 
