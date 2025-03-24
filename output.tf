output "jumpbox-ip" {
  value = module.compute.jumpbox_public_ip
}
output "wp-server-private-ips" {
  value = [ for key in module.compute.wp-server-private-ip: key ]
}
output "alb-dns" {
  value = module.alb.alb_dns
}

output "rds" {
  value = module.rds-mysql.rds_endpoint
}
output "rds-address" {
  value = module.rds-mysql.address_endpoint
}