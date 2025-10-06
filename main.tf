terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Decide architecture based on instance family
locals {
  arch = startswith(var.instance_type, "t4g.") ? "arm64" : "x86_64"
}

# Grab the latest Amazon Linux 2023 AMI for the correct architecture via SSM
# (No need to hardcode AMI IDs per region)
data "aws_ssm_parameter" "al2023" {
  name = local.arch == "arm64"
    ? "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
    : "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "free_tier" {
  ami           = data.aws_ssm_parameter.al2023.value
  instance_type = var.instance_type

  # Optional: add a tiny 8 GiB gp3 root volume (still Free Tier–friendly)
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  # Optional: simple user data (comment out if you don't want it)
  user_data = <<-EOF
              #!/bin/bash
              dnf -y update
              echo "Hello from $(hostname)" > /var/www/html/index.html
              EOF

  tags = {
    Name = var.name
  }
}
