resource "aws_s3_bucket" "recording"{
    bucket = "${var.env}-${var.project}-recording"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "recording" {
  bucket = aws_s3_bucket.recording.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "recording" {
  bucket = aws_s3_bucket.recording.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "recording" {
  bucket = aws_s3_bucket.recording.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "recording" {
  bucket = aws_s3_bucket.recording.id
  versioning_configuration {
    status = "Enabled"
  }
}