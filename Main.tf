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
# EC2
# -----------------------

module "ec2" {
  source   = "./modules/ec2"
  key_name = var.key_name
  tags     = var.tags

  instances = {
    frontend = {
      ami           = var.ec2_amis["frontend"]
      instance_type = "t3.small"
      subnet_id     = values(module.network.public_subnets)[0]
      sg_ids        = [module.frontend_sg.sg_id]
    },
    backend = {
      ami           = var.ec2_amis["backend"]
      instance_type = "t3.micro"
      subnet_id     = values(module.network.private_subnets)[0]
      sg_ids        = [module.backend_sg.sg_id]
    }
  }
}




# -----------------------
# OPTIONAL: Auto Scaling Group (commented)
# -----------------------
# Use modules/asg if you want autoscaling instead of single EC2s
#module "wordpress_asg" {
#  source         = "./modules/asg"
#  name           = var.asg_name
#  ami_id         = var.asg_ami
#  instance_type  = var.asg_instance_type
#  subnet_ids     = [module.network.public_subnet_id]
#  sg_ids         = [module.instance_sg.sg_id]
#  key_name       = var.key_name
#  desired_capacity = var.asg_desired_capacity
#  min_size       = var.asg_min_size
#  max_size       = var.asg_max_size
#}



#Subnets using in for each. Nothing hard coded 2 or 4
#Use Images with a resource in terraform named: data
#Check backend if it works with the lock
#auto scale, VMS and launch template as modules


# -----------------------
# ANSIBLE NODES #Commented as it isn't done yet.
# -----------------------
#module "ansible_nodes" {
#  source             = "./modules/Ansible"
#  subnet_id          = module.network.public_subnet_id   
#  security_group_ids = [module.network.default_sg_id]    
#  key_name           = "SKYoussefKey.pem"
#  ami_id             = data.aws_ami.ubuntu.id
#  instance_type      = "t3.micro"
#}


# -----------------------
# OUTPUTS
# -----------------------






