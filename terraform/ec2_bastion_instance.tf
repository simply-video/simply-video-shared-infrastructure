data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_eip" "eip-bastion-main" {
  vpc      = true
  instance = aws_instance.ec2-instance-bastion.id

  tags = {
    Name = "${var.env}-${var.project}-eip-bastion"

  }
}

resource "aws_instance" "ec2-instance-bastion" {
  ami                         = data.aws_ami.latest-ubuntu.id
  key_name                    = aws_key_pair.ssh-key-bastion.key_name
  instance_type               = "t3.nano"
  security_groups             = [aws_security_group.sg-pub-bastion.id]
  subnet_id                   = aws_subnet.sub-pub-main[0].id
  monitoring                  = true
  disable_api_termination     = false
  associate_public_ip_address = true

  #ignore subnet changes, caused by instance self-referrencing in security group, ignore public IP change with every stop/start too
  lifecycle {
    ignore_changes = [security_groups]
  }

  tags = {
    Name = "${var.env}-${var.project}-bastion-host"

  }

  volume_tags = {
    Name = "${var.env}-${var.project}-bastion-host-volume"
  }

  user_data = <<EOF
#! /bin/bash
sudo apt update
sudo apt install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
  EOF
}