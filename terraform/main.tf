
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region for the infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique name for the private security evidence bucket."
  type        = string
}

resource "aws_s3_bucket" "evidence" {
  bucket = var.bucket_name

  force_destroy = false

  tags = {
    Project     = "Secure-AWS-Foundation"
    Environment = "Lab"
    ManagedBy   = "Terraform"
    DataClass   = "SecurityEvidence"
  }
}

resource "aws_s3_bucket_public_access_block" "evidence" {
  bucket = aws_s3_bucket.evidence.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "evidence" {
  description             = "KMS key for security evidence bucket"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Project   = "Secure-AWS-Foundation"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "evidence" {
  bucket = aws_s3_bucket.evidence.id

  rule {
    
apply_server_side_encryption_by_default {
  sse_algorithm     = "aws:kms"
  kms_master_key_id = aws_kms_key.evidence.arn
}
    }

   
  }


resource "aws_s3_bucket_versioning" "evidence" {
  bucket = aws_s3_bucket.evidence.id

  versioning_configuration {
    status = "Enabled"
  }
}
