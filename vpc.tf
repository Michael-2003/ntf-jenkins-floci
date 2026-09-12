# Simulated VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-vpc"
    Env  = var.env
  }
}

# Simulated Subnets (public)
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-public-${count.index}"
    Env  = var.env
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-igw"
  }
}

# Simulated EC2 (Floci launches a real Docker container behind the scenes)
resource "aws_instance" "app" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "${var.env}-app"
    Env  = var.env
  }
}

# Simulated S3 Bucket
resource "aws_s3_bucket" "data" {
  bucket = var.bucket_name
  tags = {
    Name = var.bucket_name
    Env  = var.env
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = aws_subnet.public[*].id
}

output "instance_id" {
  value = aws_instance.app.id
}

output "bucket_name" {
  value = aws_s3_bucket.data.id
}
