output "instance_id" {
  value = aws_instance.free_tier.id
}

output "public_ip" {
  value = aws_instance.free_tier.public_ip
}
