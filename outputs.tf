# -----------------------
# OUTPUTS
# -----------------------

# EC2 public IP map
output "ec2_public_ip_map" {
  description = "Map of instance name => public IP"
  value       = { for name, ip in module.ec2.public_ips : name => ip }
}

# EC2 private IP map
output "ec2_private_ip_map" {
  description = "Map of instance name => private IP"
  value       = { for name, inst in module.ec2.instances : name => inst.private_ip }
}

# List of EC2 public IPs
output "ec2_public_ips" {
  description = "List of public IPs"
  value       = [for ip in values(module.ec2.public_ips) : ip]
}

# VPC ID 
output "vpc_id" {
  value = module.network.vpc_id
}

# Subnets 
output "public_subnets" {
  value = module.network.public_subnets
}

output "private_subnets" {
  value = module.network.private_subnets
}
