variable "region" {
  description = "AWS region (any works with Floci)"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment name: dev / stg / prod"
  type        = string
  default     = "dev"
}

variable "aws_endpoint" {
  description = "Floci endpoint URL"
  type        = string
  default     = "http://floci:4566"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami" {
  description = "Floci falls back to amazonlinux:2023 for unknown AMIs"
  type        = string
  default     = "ami-0c101f26f147fa7fd"
}

variable "bucket_name" {
  description = "Simulated S3 bucket (must be globally unique per env)"
  type        = string
  default     = "my-app-bucket-dev"
}
