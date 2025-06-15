output "instance_ip" {
  description = "IP address for VM"
  value       = aws_instance.ec2_insance.public_ip
}