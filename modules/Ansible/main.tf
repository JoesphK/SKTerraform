provider "aws" {
  region = "us-east-1"
}

# Lookup all EC2 instances by tag
data "aws_instances" "filtered" {
  filter {
    name   = "tag:${var.tag_key}"
    values = [var.tag_value]
  }
}

# Get the public IPs of those instances
data "aws_instance" "instances" {
  for_each   = toset(data.aws_instances.filtered.ids)
  instance_id = each.value
}

resource "null_resource" "ansible_run" {
  provisioner "local-exec" {
    interpreter = ["wsl", "bash", "-c"]
    command = <<-EOT
      ansible-playbook -i '${join(",", [for i in data.aws_instance.instances : i.public_ip])},' \
      /mnt/c/Users/User/Desktop/Studies/SilverKey/TerraForm/SKTerraform/modules/Ansible/playbook.yml \
      --private-key /root/.ssh/youssefkeypair.pem \
      -u ubuntu \
      --ssh-common-args='-o StrictHostKeyChecking=no'
    EOT
  }

  depends_on = [data.aws_instance.instances]
}



