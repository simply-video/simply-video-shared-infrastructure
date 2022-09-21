// Generate Password
resource "random_password" "db_password" {
  length           = 64
  special          = true #   Default: !@#$%&*()-_=+[]{}<>:?
  override_special = "#!()_<>"
}

// Store Password
resource "aws_ssm_parameter" "rds_password" {
  name        = "/${var.project}/${var.env}/rds/password"
  description = "Master Password for RDS Database"
  type        = "SecureString"
  value       = random_password.db_password.result
}

// Retrieve Password
data "aws_ssm_parameter" "rds_password" {
  name       = aws_ssm_parameter.rds_password.name
  depends_on = [aws_ssm_parameter.rds_password]
}



#######
# pexip
#######

resource "aws_ssm_parameter" "PEXIP_PASSWORD" {
  name  = "/${var.project}/${var.env}/pexip/password"
  type  = "SecureString"
  value = var.PEXIP_PASSWORD
}
data "aws_ssm_parameter" "PEXIP_PASSWORD" {
  name       = aws_ssm_parameter.PEXIP_PASSWORD.name
  depends_on = [aws_ssm_parameter.PEXIP_PASSWORD]
}

resource "aws_ssm_parameter" "PEXIP_USER" {
  name  = "/${var.project}/${var.env}/pexip/user"
  type  = "SecureString"
  value = var.PEXIP_USER
}
data "aws_ssm_parameter" "PEXIP_USER" {
  name       = aws_ssm_parameter.PEXIP_USER.name
  depends_on = [aws_ssm_parameter.PEXIP_USER]
}


#######
# mail
#######
resource "aws_ssm_parameter" "MAIL_USERNAME" {
  name  = "/${var.project}/${var.env}/mail/user"
  type  = "SecureString"
  value = var.MAIL_USERNAME
}
data "aws_ssm_parameter" "MAIL_USERNAME" {
  name       = aws_ssm_parameter.MAIL_USERNAME.name
  depends_on = [aws_ssm_parameter.MAIL_USERNAME]
}

resource "aws_ssm_parameter" "MAIL_PASSWORD" {
  name  = "/${var.project}/${var.env}/mail/password"
  type  = "SecureString"
  value = var.MAIL_PASSWORD
}
data "aws_ssm_parameter" "MAIL_PASSWORD" {
  name       = aws_ssm_parameter.MAIL_PASSWORD.name
  depends_on = [aws_ssm_parameter.MAIL_PASSWORD]
}

resource "aws_ssm_parameter" "recording_key_id" {
  name  = "/${var.project}/${var.env}/recording_storage/key_id"
  type  = "SecureString"
  value = aws_iam_access_key.recording.id
}

resource "aws_ssm_parameter" "recording_secret" {
  name  = "/${var.project}/${var.env}/recording_storage/secret"
  type  = "SecureString"
  value = aws_iam_access_key.recording.secret
}


resource "aws_ssm_parameter" "PUSHER_APP_KEY" {
  name  = "/${var.project}/${var.env}/chat/PUSHER_APP_KEY"
  type  = "SecureString"
  value = var.PUSHER_APP_KEY
}
data "aws_ssm_parameter" "PUSHER_APP_KEY" {
  name       = aws_ssm_parameter.PUSHER_APP_KEY.name
  depends_on = [aws_ssm_parameter.PUSHER_APP_KEY]
}