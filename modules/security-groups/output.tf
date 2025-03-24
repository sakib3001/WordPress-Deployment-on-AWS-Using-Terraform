output "wp-server-sg-id" {
  value = aws_security_group.wp-server-sg.id
}

output "jumpbox-sg-id" {
  value = aws_security_group.jumpbox-sg.id
}

output "alb-sg-id" {
  value = aws_security_group.wp-alb-sg.id
}

output "rds-sg-id" {
  value = aws_security_group.rds_sg.id
}
