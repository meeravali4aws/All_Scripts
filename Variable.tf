variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "Optional explicit AMI ID. Leave empty to auto-select Ubuntu 22.04"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.nano"
}

variable "subnet_id" {
  description = "Target subnet ID for this instance"
  type        = string
}

variable "security_group_ids" {
  description = "List of Security Group IDs to attach"
  type        = list(string)
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "iam_instance_profile" {
  description = "Optional IAM instance profile name (not ARN)"
  type        = string
  default     = null
}

variable "associate_public_ip" {
  description = "Attach a public IP (use true only for public subnets)"
  type        = bool
  default     = true
}

variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
  default     = "demo-ec2"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 8
}

variable "user_data" {
  description = "Optional cloud-init/user_data script"
  type        = string
  default     = <<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOT
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
