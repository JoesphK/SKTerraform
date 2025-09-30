variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default     = "10.1.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default     = "10.1.2.0/24"
}

variable "wordpress_ami" {
  description = "AMI ID for WordPress"
  default     = "ami-08d773dde7e3cf7a4"
}

variable "wordpress_instance_type" {
  description = "EC2 instance type for WordPress"
  default     = "t3.small"
}

variable "db_ami" {
  description = "AMI ID for Database"
  default     = "ami-03d64a68bd3196240"
}

variable "db_instance_type" {
  description = "EC2 instance type for Database"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  default     = "SKYoussefKey"
}
