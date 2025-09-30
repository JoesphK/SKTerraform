variable "subnet_id" {
  type        = string
  description = "Public subnet ID"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups for Ansible nodes"
}

variable "key_name" {
  type        = string
  description = "SSH key name"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the nodes"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

resource "aws_instance" "ansible_nodes" {
  count         = 2
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name      = var.key_name

  tags = {
    Name = "ansible-node-${count.index + 1}"
  }
}

output "public_ips" {
  value = aws_instance.ansible_nodes[*].public_ip
}

output "private_ips" {
  value = aws_instance.ansible_nodes[*].private_ip
}
