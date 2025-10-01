output "ec2_instance_ids" {
  description = "IDs of filtered EC2 instances"
  value       = data.aws_instances.filtered.ids
}

output "ec2_public_ips" {
  description = "Public IPs of filtered EC2 instances"
  value       = [for i in data.aws_instance.instances : i.public_ip]
}
