terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# -----------------------
# NETWORK MODULE
# -----------------------
module "network" {
  source = "./modules/network"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}


# -----------------------
# SECURITY GROUP (Frontend)
# -----------------------
module "frontend_sg" {
  source        = "./modules/securityGroups"
  name          = "frontend-sg"
  description   = "Frontend SG (HTTP + SSH)"
  vpc_id        = module.network.vpc_id
  ingress_rules = var.frontend_ingress_rules
  egress_rules  = var.instance_egress_rules
  tags          = var.tags
}

# -----------------------
# SECURITY GROUP (Backend)
# -----------------------
module "backend_sg" {
  source        = "./modules/securityGroups"
  name          = "backend-sg"
  description   = "Backend SG (SSH + MySQL)"
  vpc_id        = module.network.vpc_id
  ingress_rules = var.backend_ingress_rules
  egress_rules  = var.instance_egress_rules
  tags          = var.tags
}

# -----------------------
# Server EC2
# -----------------------

module "ec2" {
  source   = "./modules/ec2"
  key_name = var.key_name
  tags     = var.tags

  instances = {

    Youssefbackend = {
      ami_id        = var.ec2_amis["db-image-node"]
      instance_type = "t3.micro"
      subnet_id     = values(module.network.private_subnets)[0]
      sg_ids        = [module.backend_sg.sg_id]
      tags          = merge(var.tags, { "Name" = "YoussefBackEnd" })
    }
  }
}




# -----------------------
# Auto Scaling Group
# -----------------------


module "frontend_asg" {
  source         = "./modules/asg"
  name           = "YoussefFrontend"
  ami_id         = var.ec2_amis["wordpress-node"]
  instance_type  = "t3.small"
  subnet_ids     = values(module.network.public_subnets)   # all public subnets
  sg_ids         = [module.frontend_sg.sg_id]
  key_name       = var.key_name
  desired_capacity = 1
  min_size         = 1
  max_size         = 2
}


# -----------------------
# Create two machines to run the ansible playbook
# -----------------------

module "ansible_nodes" {
  source   = "./modules/ec2"
  key_name = var.key_name
  tags     = var.tags

  instances = {
    Youssef-ansible-1 = {
      ami_id        = data.aws_ami.ubuntu.id   # Default Ubuntu AMI
      instance_type = "t3.micro"
      subnet_id     = values(module.network.public_subnets)[0]
      sg_ids        = [module.frontend_sg.sg_id]  # Or a dedicated SG
      tags          = merge(var.tags, { "Role" = "ansible"
                                        "Name" = "Joe-Ansible-machine-1" })
    }

    Youssef-ansible-2 = {
      ami_id        = data.aws_ami.ubuntu.id
      instance_type = "t3.micro"
      subnet_id     = values(module.network.public_subnets)[0]
      sg_ids        = [module.frontend_sg.sg_id]
      tags          = merge(var.tags, { "Role" = "ansible"
                                        "Name" = "Joe-Ansible-machine-2" })
    }
  }
}

# Look up the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}







# -----------------------
# The ansible playbook
# -----------------------
module "wordpress_ansible" {
  source = "./modules/ansible"

  tag_key             = "Role"                # the tag key to filter EC2s
  tag_value           = "ansible"           # the tag value to filter EC2s
  ansible_playbook    = "playbook.yml"       # relative path to playbook
  ssh_user            = "ubuntu"              # SSH username
  ssh_private_key_path = "/home/ubuntu/.ssh/youssefkeypair.pem"      # path to private key. It's in the WSL
}





#Subnets using in for each. Nothing hard coded 2 or 4 Done
#Use Images with a resource in terraform named: data
#Check backend if it works with the lock Done
#auto scale, VMS and launch template as modules 


