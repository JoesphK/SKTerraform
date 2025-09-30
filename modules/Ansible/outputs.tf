output "ansible_nodes_public_ips" {
  description = "Public IPs of the Ansible nodes"
  value       = aws_instance.ansible_nodes[*].public_ip #outputs public ip
}

output "ansible_nodes_private_ips" {
  description = "Private IPs of the Ansible nodes"
  value       = aws_instance.ansible_nodes[*].private_ip #Outputs private ip
}
