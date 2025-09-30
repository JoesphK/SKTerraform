terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# -----------------------
# Variables (example values)
# -----------------------
# You can move these to root variables.tf if needed
locals {
  vpc_cidr             = "10.1.0.0/16" #CDIR Block
  public_subnet_cidr   = "10.1.1.0/24" #Public Sub
  private_subnet_cidr  = "10.1.2.0/24" #Private Sub
  availability_zone    = "us-east-1a" #AZ
  wordpress_ami        = "ami-08d773dde7e3cf7a4" #AMI From images
  db_ami               = "ami-03d64a68bd3196240" #AMI From images
  wordpress_instance   = "t3.small" #Size
  db_instance          = "t3.micro" #Size
  key_name             = "SKYoussefKey" #Keypair
}

# -----------------------
# NETWORK MODULE
# -----------------------
module "network" { #Fetch from modules/network
  source               = "./modules/network"
  vpc_cidr             = local.vpc_cidr
  public_subnet_cidr   = local.public_subnet_cidr
  private_subnet_cidr  = local.private_subnet_cidr
  availability_zone    = local.availability_zone
}

# -----------------------
# SECURITY GROUPS
# -----------------------
resource "aws_security_group" "wordpress_sg" { #Create the SGs here so it will be easier for me to find them.
  name        = "wordpress-sg-Youssef" #Public access
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "JoeSKTask-WordPress-SG"
  }
}

resource "aws_security_group" "db_sg" { #Private access
  name        = "db-sg-Youssef"
  description = "Allow MySQL from WordPress and SSH for admin"
  vpc_id      = module.network.vpc_id

  ingress {
    description     = "MySQL from WordPress SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  ingress {
    description = "SSH (for admin)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "JoeSKTask-DB-SG"
  }
}

# -----------------------
# WORDPRESS MODULE
# -----------------------
module "wordpress" { #Run wordpress module
  source             = "./modules/wordpress"
  vpc_id             = module.network.vpc_id
  public_subnet_id   = module.network.public_subnet_id
  wordpress_ami      = local.wordpress_ami
  instance_type      = local.wordpress_instance
  key_name           = local.key_name
  wordpress_sg_id    = aws_security_group.wordpress_sg.id
}

# -----------------------
# DATABASE MODULE
# -----------------------
module "database" { #Run DB module
  source             = "./modules/database"
  vpc_id             = module.network.vpc_id
  private_subnet_id  = module.network.private_subnet_id
  db_ami             = local.db_ami
  db_instance_type   = local.db_instance
  key_name           = local.key_name
  wordpress_sg_id    = aws_security_group.wordpress_sg.id
  
}


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


output "wordpress_public_ip" {
  description = "Public IP(s) of the WordPress instance(s)"
  value       = module.wordpress.public_ips
}





