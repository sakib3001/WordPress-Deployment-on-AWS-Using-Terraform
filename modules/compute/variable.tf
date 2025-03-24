variable "instance_type" {
  type = map(string)
  default = {
    "dev"   = "t2.micro"
    "stage" = "t2.medium"
    "prod"  = "t2.large"
  }
}

variable "ami" {
  default = "ami-04b4f1a9cf54c11d0"
}

variable "public_key_path" {
  default = "/home/sakib/.ssh/id_rsa.pub"
}

variable "wp-server-sg" {

}

variable "jumpbox-sg" {

}
variable "private_subnet_ids" {

}
variable "public_subnet_id" {

}