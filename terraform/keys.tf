
data "aws_kms_key" "kms-rds-main" {
  key_id = "arn:aws:kms:${var.aws_region}:${aws_vpc.vpc-main.owner_id}:alias/aws/rds"
}

data "aws_kms_key" "kms-es-main" {
  key_id = "arn:aws:kms:${var.aws_region}:${aws_vpc.vpc-main.owner_id}:alias/aws/es"
}

resource "aws_key_pair" "ssh-key-bastion" {
  key_name   = "${var.env}-${var.project}-bastion-ssh"
  public_key = var.auth_bastion_ssh_key
}