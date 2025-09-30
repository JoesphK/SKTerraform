resource "aws_instance" "this" {
  for_each = var.instances

  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = each.value.sg_ids
  key_name               = var.key_name

  tags = merge(
    var.tags,
    { "Name" = each.key }
  )
}
