region = "us-east-1"

# network
vpc_cidr            = "10.1.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]


# Key
key_name = "SKYoussefKey"

# EC2 instances: create one instance per entry (name => ami)
ec2_amis = {
  "wordpress-node" = "ami-08d773dde7e3cf7a4"
  "db-image-node"  = "ami-03d64a68bd3196240"
}

ec2_instance_type = "t3.small"


# Security group rules for instances: example allowing SSH + HTTP
frontend_ingress_rules = [
  {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

backend_ingress_rules = [
  {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    description = "Allow MySQL from within VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]
