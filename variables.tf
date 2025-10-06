variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Free Tier–eligible type: t2.micro, t3.micro, or t4g.micro"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^(t2|t3|t4g)\\.micro$", var.instance_type))
    error_message = "Use t2.micro, t3.micro, or t4g.micro (all Free Tier–eligible in supported regions)."
  }
}

variable "name" {
  description = "Name tag for the instance"
  type        = string
  default     = "free-tier-ec2"
}
