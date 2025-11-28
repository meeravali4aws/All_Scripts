aws_region         = "ap-south-1"
subnet_id          = "subnet-060a1c3094219e677"    # your subnet
security_group_ids = ["sg-02bec84a2cc008aeb"]      # your SGs
key_name           = "Aws_key"         # must exist in AWS
instance_name      = "web-prod-01"
associate_public_ip = true                         # set false for private subnet
tags = {
  Owner       = "meeravali"
  CostCenter  = "Prod-001"
  Environment = "prod"
}
