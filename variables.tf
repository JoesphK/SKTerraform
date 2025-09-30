# Provider / region
variable "region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

# Network
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDRs"
  default     = ["10.1.1.0/24", "10.1.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDRs"
  default     = ["10.1.2.0/24", "10.1.4.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones for subnets"
  default     = ["us-east-1a", "us-east-1b"]
}

# Key pair
variable "key_name" {
  type        = string
  description = "Name of the AWS key pair (not the .pem file path)"
  default     = "SKYoussefKey"
}

# EC2 instances
variable "ec2_amis" {
  description = "Map (name => ami) for EC2 instances. Terraform will create one EC2 per key."
  type        = map(string)
  default     = {}
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type for instances"
  default     = "t3.small"
}

# Security group inputs
variable "instance_sg_name" {
  type        = string
  description = "Name for the instance security group"
  default     = "instance-sg"
}

variable "instance_sg_description" {
  type        = string
  description = "Description for the instance security group"
  default     = "Instance SG (SSH/HTTP/etc.)"
}

variable "instance_ingress_rules" {
  description = "List of ingress rules to pass to SG module"
  type = list(object({
    description     = optional(string)
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
  }))
  default = []
}

variable "instance_egress_rules" {
  description = "List of egress rules to pass to SG module"
  type = list(object({
    description = optional(string)
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string))
  }))
  default = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# Generic tags
variable "tags" {
  type    = map(string)
  default = {}
}

# Optional ASG variables (kept for later)
variable "asg_name" {
  type    = string
  default = "wordpress-asg"
}

variable "asg_ami" {
  type    = string
  default = ""
}

variable "asg_instance_type" {
  type    = string
  default = "t3.small"
}

variable "asg_desired_capacity" {
  type    = number
  default = 2
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 3
}

variable "frontend_ingress_rules" {
  description = "Ingress rules for frontend SG"
  type = list(object({
    description     = optional(string)
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
  }))
}

variable "backend_ingress_rules" {
  description = "Ingress rules for backend SG"
  type = list(object({
    description     = optional(string)
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
  }))
}
