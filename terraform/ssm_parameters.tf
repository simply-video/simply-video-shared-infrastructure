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

resource "aws_ssm_parameter" "PEXIP_WEBHOOKS_USER" {
  name  = "/${var.project}/${var.env}/pexip/webhook_user"
  type  = "SecureString"
  value = var.PEXIP_WEBHOOKS_USER
}
data "aws_ssm_parameter" "PEXIP_WEBHOOKS_USER" {
  name       = aws_ssm_parameter.PEXIP_WEBHOOKS_USER.name
  depends_on = [aws_ssm_parameter.PEXIP_WEBHOOKS_USER]
}

resource "aws_ssm_parameter" "PEXIP_WEBHOOKS_PASSWORD" {
  name  = "/${var.project}/${var.env}/pexip/webhook_password"
  type  = "SecureString"
  value = var.PEXIP_WEBHOOKS_PASSWORD
}
data "aws_ssm_parameter" "PEXIP_WEBHOOKS_PASSWORD" {
  name       = aws_ssm_parameter.PEXIP_WEBHOOKS_PASSWORD.name
  depends_on = [aws_ssm_parameter.PEXIP_WEBHOOKS_PASSWORD]
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
data "aws_ssm_parameter" "recording_key_id" {
  name       = aws_ssm_parameter.recording_key_id.name
  depends_on = [aws_ssm_parameter.recording_key_id]
}

resource "aws_ssm_parameter" "recording_secret" {
  name  = "/${var.project}/${var.env}/recording_storage/secret"
  type  = "SecureString"
  value = aws_iam_access_key.recording.secret
}
data "aws_ssm_parameter" "recording_secret" {
  name       = aws_ssm_parameter.recording_secret.name
  depends_on = [aws_ssm_parameter.recording_secret]
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

resource "aws_ssm_parameter" "PUSHER_APP_ID" {
  name  = "/${var.project}/${var.env}/chat/PUSHER_APP_ID"
  type  = "SecureString"
  value = var.PUSHER_APP_ID
}
data "aws_ssm_parameter" "PUSHER_APP_ID" {
  name       = aws_ssm_parameter.PUSHER_APP_ID.name
  depends_on = [aws_ssm_parameter.PUSHER_APP_ID]
}

resource "aws_ssm_parameter" "PUSHER_APP_SECRET" {
  name  = "/${var.project}/${var.env}/chat/PUSHER_APP_SECRET"
  type  = "SecureString"
  value = var.PUSHER_APP_SECRET
}
data "aws_ssm_parameter" "PUSHER_APP_SECRET" {
  name       = aws_ssm_parameter.PUSHER_APP_SECRET.name
  depends_on = [aws_ssm_parameter.PUSHER_APP_SECRET]
}

resource "aws_ssm_parameter" "PUSHER_APP_CLUSTER" {
  name  = "/${var.project}/${var.env}/chat/PUSHER_APP_CLUSTER"
  type  = "SecureString"
  value = var.PUSHER_APP_CLUSTER
}
data "aws_ssm_parameter" "PUSHER_APP_CLUSTER" {
  name       = aws_ssm_parameter.PUSHER_APP_CLUSTER.name
  depends_on = [aws_ssm_parameter.PUSHER_APP_CLUSTER]
}

resource "aws_ssm_parameter" "chat_key_id" {
  name  = "/${var.project}/${var.env}/chat_storage/key_id"
  type  = "SecureString"
  value = aws_iam_access_key.chat.id
}
data "aws_ssm_parameter" "chat_key_id" {
  name       = aws_ssm_parameter.chat_key_id.name
  depends_on = [aws_ssm_parameter.chat_key_id]
}
resource "aws_ssm_parameter" "chat_secret" {
  name  = "/${var.project}/${var.env}/chat_storage/secret"
  type  = "SecureString"
  value = aws_iam_access_key.chat.secret
}
data "aws_ssm_parameter" "chat_secret" {
  name       = aws_ssm_parameter.chat_secret.name
  depends_on = [aws_ssm_parameter.chat_secret]
}