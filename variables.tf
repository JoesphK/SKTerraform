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
  default     = ["10.1.10.0/24", "10.1.11.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDRs"
  default     = ["10.1.12.0/24", "10.1.13.0/24"]
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


variable "eks_nodes_ingress_rules" {
  description = "Ingress rules for EKS node security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}

variable "instance_egress_rules" {
  description = "Egress rules for security groups"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}


# Generic tags
variable "tags" {
  type    = map(string)
  default = {}
}

# Optional ASG variables (kept for later)
variable "asg_name" {
  type    = string
  default = "wordpress-youssef"
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
  default = 1
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 3
}



variable "eks_cluster_iam" {
  description = "IAM configuration for the EKS cluster role"
  type = object({
    role_name           = string
    assume_services     = list(string)
    managed_policy_arns = list(string)
    tags                = optional(map(string), {})
  })
}

variable "eks_node_iam" {
  description = "IAM configuration for the EKS node role"
  type = object({
    role_name           = string
    assume_services     = list(string)
    managed_policy_arns = list(string)
    tags                = optional(map(string), {})
  })
}

variable "cluster_name" {
  type    = string
  default = "sk-eks-cluster"
}

variable "cluster_version" {
  type    = string
  default = "1.30"
}

variable "node_group_name" {
  type    = string
  default = "sk-node-group"
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "desired_size" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}
variable "node_role_arn" {
  description = "Optional: ARN of the IAM role for EKS nodes. If empty, uses module.eks_node_role.role_arn."
  type        = string
  default     = ""
}

variable "admin_iam_user" {
  description = "IAM user ARN to grant admin access to the cluster"
  type        = string
}

# Addons & cluster settings
variable "cluster_enabled_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

# Access entries to map IAM principals -> kubernetes groups & policy association
# Example structure in terraform.tfvars:
# eks_access_entries = [
#   { principal_arn = "arn:aws:iam::123:role/my-admin" , groups = ["system:masters"], policy = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy" }
# ]
variable "eks_access_entries" {
  type = list(object({
    principal_arn       = string
    kubernetes_groups   = optional(list(string), [])
    kubernetes_username = optional(string, null)
    access_policy_arn   = optional(string, null)
  }))
  default = []
}

# Addon config for CoreDNS if you want (optional)
variable "coredns_config" {
  type    = map(any)
  default = {}
}
