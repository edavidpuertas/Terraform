output "ec2_public_ip" {
  description = "Instance public IP"
  value       = aws_instance.public_instance.public_ip

}