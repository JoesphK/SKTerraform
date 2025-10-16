# -----------------------
# OUTPUTS
# -----------------------


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



