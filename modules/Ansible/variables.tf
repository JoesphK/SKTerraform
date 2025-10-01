variable "tag_key" {
  description = "The tag key to filter EC2 instances"
  type        = string
  default     = "Role"
}

variable "tag_value" {
  description = "The tag value to filter EC2 instances"
  type        = string
  default     = "wordpress"
}

variable "ansible_playbook" {
  description = "Path to the Ansible playbook to run"
  type        = string
  default     = "playbook.yml"
}

variable "ssh_user" {
  description = "SSH username to connect to EC2"
  type        = string
  default     = "ubuntu"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key for EC2 access"
  type        = string
}
