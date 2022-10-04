provider "aws" {
    region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_statefile_store"{
    bucket = "simply-video-terraform-state"

    lifecycle {
      prevent_destroy = true
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_statefile_store" {
  bucket = aws_s3_bucket.terraform_statefile_store.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "terraform_statefile_store" {
  bucket = aws_s3_bucket.terraform_statefile_store.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "terraform_statefile_store" {
  bucket = aws_s3_bucket.terraform_statefile_store.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_statefile_store" {
  bucket = terraform_statefile_store.chat.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}