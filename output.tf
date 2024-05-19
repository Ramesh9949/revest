
output "id" {
  description = "give the of IDs of instance"
  value       = ["${aws_instance.web-1.id}"]
}

output "key_name" {
  description = "it give the key name of instance"
  value       = ["${aws_instance.web-1.key_name}"]
}

output "public_dns" {
  description = "give the public DNS name assigned to the instance"
  value       = ["${aws_instance.web-1.public_dns}"]
}

output "public_ip" {
  description = "List of public IP address assigned to the instance, if applicable"
  value       = ["${aws_instance.web-1.public_ip}"]
}

output "private_dns" {
  description = "give the private DNS name assigned to the instance"
  value       = ["${aws_instance.web-2.private_dns}"]
}

output "private_ip" {
  description = "give the private IP addresses assigned to the instances"
  value       = ["${aws_instance.web-2.private_ip}"]
}


