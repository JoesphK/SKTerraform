variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet"
  type        = string
}

variable "db_ami" {
  description = "AMI ID for the database server"
  type        = string
}

variable "db_instance_type" {
  description = "EC2 instance type for database"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "wordpress_sg_id" {
  description = "Security group ID of WordPress instances for DB access"
  type        = string
}
