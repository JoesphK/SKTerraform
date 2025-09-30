# -----------------------
# OUTPUTS
# -----------------------

# Map name -> public IP
output "ec2_public_ip_map" {
  description = "Map of instance name => public IP"
  value       = module.ec2.public_ips
}

# Map name -> private IP
output "ec2_private_ip_map" {
  description = "Map of instance name => private IP"
  value       = module.ec2.private_ips
}

# List of security group IDs for the instances
output "instance_sg_ids" {
  description = "Security Group IDs used for instances"
  value       = [module.frontend_sg.sg_id, module.backend_sg.sg_id]
}

# VPC ID
output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}
