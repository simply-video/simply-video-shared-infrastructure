data "aws_caller_identity" "current" {}

data "aws_iam_policy" "amazon-ecs-task-execution-role-policy" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

# ecs role and policy
resource "aws_iam_role" "ecs-task-execution-role" {
  name = "${var.env}-${var.project}-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
  ] })

  inline_policy {
    name = "GetParamsFromSSM"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameters",
            "ssm:GetParameter"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
          ],
          "Resource" : "*"
        }
      ]
    })
  }
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-attach-policy" {
  role       = aws_iam_role.ecs-task-execution-role.id
  policy_arn = data.aws_iam_policy.amazon-ecs-task-execution-role-policy.arn
}


#########
# reconrdig user
#########

resource "aws_iam_user" "recording" {
  name = "${var.env}-${var.project}-recording_user"
}
resource "aws_iam_access_key" "recording" {
  user = aws_iam_user.recording.name
}
resource "aws_iam_user_policy" "recording" {
  name = "${var.env}-${var.project}-recording_policy"
  user = aws_iam_user.recording.name
  policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:ListBucket",
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:PutObjectAcl"
          ],
            "Resource": [
                "${aws_s3_bucket.recording.arn}/*",
                "${aws_s3_bucket.recording.arn}"
            ]
        }
      ]
    })
}


#########
# chat user
#########

resource "aws_iam_user" "chat" {
  name = "${var.env}-${var.project}-chat_user"
}
resource "aws_iam_access_key" "chat" {
  user = aws_iam_user.chat.name
}
resource "aws_iam_user_policy" "chat" {
  name = "${var.env}-${var.project}-chat_policy"
  user = aws_iam_user.chat.name
  policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:ListBucket",
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:PutObjectAcl"
          ],
            "Resource": [
                "${aws_s3_bucket.chat.arn}/*",
                "${aws_s3_bucket.chat.arn}"
            ]
        }
      ]
    })
}