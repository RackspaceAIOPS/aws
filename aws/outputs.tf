output "instance_id" {
  description = "ID of the provisioned EC2 instance."
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IPv4 address assigned to the EC2 instance, if any."
  value       = aws_instance.this.public_ip
}