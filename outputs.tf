output "db_private_ip" {
  description = "Private IP of the DB instance"
  value       = module.database.db_private_ip
}

output "wordpress_asg_name" {
  description = "Name of the WordPress Auto Scaling Group"
  value       = module.wordpress.asg_name
}


output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}


