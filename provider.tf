terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Floci = LocalStack-compatible endpoint. From Jenkins container use http://floci:4566,
# from Windows host use http://localhost:4566 (override via -var or TF_VAR_aws_endpoint).
provider "aws" {
  region                      = var.region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    ec2 = var.aws_endpoint
    s3  = var.aws_endpoint
    iam = var.aws_endpoint
    sts = var.aws_endpoint
  }
}
