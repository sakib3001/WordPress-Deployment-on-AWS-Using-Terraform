output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.wp-vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [for subnet in aws_subnet.public_subnet : subnet.id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [for subnet in aws_subnet.private_subnet : subnet.id]
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.wp-nat.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.wp-public-rt.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.wp-private-rt.id
}

output "elastic_ip" {
  description = "Elastic IP assigned to the NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}
