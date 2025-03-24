variable "subnet_ids" {
     type = list(string)
}
variable "vpc_security_group_ids" {

}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}