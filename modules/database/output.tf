output "rds_endpoint" {
  value = aws_db_instance.wp-rds.endpoint
}

output "address_endpoint" {
  value = aws_db_instance.wp-rds.address
}