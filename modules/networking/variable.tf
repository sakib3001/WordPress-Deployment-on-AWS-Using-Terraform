variable "region" {
}

variable "public_subnet_cidr_blocks" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    "1" = { cidr_block = "10.0.1.0/24", az = "us-east-1a" }
    "2" = { cidr_block = "10.0.2.0/24", az = "us-east-1b" }
    "3" = { cidr_block = "10.0.3.0/24", az = "us-east-1c" }
  }
}

variable "private_subnet_cidr_blocks" {
  type = map(string)
  default = {
    # "key" = "value"
    "1" = "10.0.10.0/24"
    "2" = "10.0.20.0/24"
    "3" = "10.0.30.0/24"
  }
}