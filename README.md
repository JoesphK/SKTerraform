# Terraform infrastructure deployer
## Overview
This project aims to deploy cloud infrastructure using code using modular blocks.

## Features

- **Modular architecture** — infrastructure divided into reusable modules  
- Clear separation of **variables**, **outputs**, and **main block**  
- Easy to add new modules or resources  
- Backend state management  
- Clean, opinionated structure for maintainability  
- Currently supports:
    - Creating VPC
    - Private subnets + 1 NAT gateway
    - Public subnets + 1 IGW
    - EC2
    - Security groups
    - Auto scaling groups
    - Launch templates
##Installation
- Download the project
- Open it in visual studio
- Adjust the components you need to add/ remove in the root main.tf
- Initilize terraform using: terraform init
- Add your credentials to AWS using aws configure (You will need to install aws library in your IDE of choice/ powershell)
- Specify the bucket name that will be used to apply the lock under backend.tf
- Run terraform plan to check your infrastructure
- If successful run terraform apply -auto-approve
## Future work
- Add the creation of EKS clusters
- Add the creation of load balancers
- Add the creation of dynamoDB
- Create a UI for ease of access
