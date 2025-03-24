output "jumpbox_public_ip" {
  value = aws_instance.jumpbox.public_ip
}
output "wp-server-private-ip" {
  value = aws_instance.wp-servers[*].private_ip
}

output "wp-tg-ids" {
  value = aws_instance.wp-servers[*].id
}