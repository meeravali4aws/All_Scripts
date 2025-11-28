terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Optional: look up the AMI dynamically by name/owner (Ubuntu example)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "ec2" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name                       # must already exist in AWS
  iam_instance_profile   = var.iam_instance_profile           # optional
  associate_public_ip_address = var.associate_public_ip       # true if you want internet access (public subnet)

  # Optional user-data (e.g., install NGINX)
  user_data = var.user_data

  # Root volume
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  # Safety rails (uncomment if this is prod-critical)
   #ifecycle {
   # prevent_destroy = true
   #

  tags = merge(
    {
      Name = var.instance_name
    },
    var.tags
  )
}

output "instance_id" {
  value = aws_instance.ec2.id
}

output "public_ip" {
  value       = aws_instance.ec2.public_ip
  description = "Will be null if associate_public_ip_address = false or subnet is private"
}

output "private_ip" {
  value = aws_instance.ec2.private_ip
}
terraform {
  backend "s3" {
    bucket         = "ter-jasdfnsdn-01"    # S3 bucket name
    key            = "MandD_project/terraform.tfstate"   # Path inside bucket
    region         = "ap-south-1"                   # Bucket region
    dynamodb_table = "terraform-locks"              # DynamoDB table name
    encrypt        = true                           # Encrypt the state file in S3
  }
}