resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow MySQL from WordPress"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.wordpress_sg_id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "db_instance" {
  ami                    = var.db_ami
  instance_type          = var.db_instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  key_name               = var.key_name
}

output "db_private_ip" {
  description = "Private IP of the DB instance"
  value       = aws_instance.db_instance.private_ip
}

