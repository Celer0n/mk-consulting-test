provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_key_pair" "vm_key" {
  key_name   = "vm-aws-key"
  public_key = file("/root/.ssh/vm-aws-key.pub")
}

resource "aws_instance" "ec2_insance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.vm_key.key_name
  monitoring    = true

  user_data = <<-EOF
              
              EOF

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "optional"
  }

  # root block device
  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  # ebs block device
  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  # Network interfaced
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = {
    Name = "ec2_insance"
  }
}

resource "aws_route53_record" "insatnce" {
  zone_id = "Z0242515I8RDH0PHYY53"
  name    = "test.artembobrov.click"
  type    = "A"
  ttl     = 300
  records = [aws_instance.ec2_insance.public_ip]
}

# Security Group access for ports 80/443/22
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Allow HTTP, HTTPS, and SSH access"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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