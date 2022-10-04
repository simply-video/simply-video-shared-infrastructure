terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket  = "simply-video-terraform-state" // Bucket where to SAVE Terraform State
    key     = "xrpexip.com/terraform.tfstate"       // Object name in the bucket to SAVE Terraform State
    region  = "eu-central-1"                 // Region where bucket created
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = var.env
      Project     = var.project
    }
  }
}