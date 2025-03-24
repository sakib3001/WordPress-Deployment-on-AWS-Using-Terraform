variable "ingress_rules_wp-server" {
  default = [
    {
      port        = "22"
      description = "allowing ssh from the jumpbox"
      cidr        = "10.0.2.0/24"
    },
    {
      port        = "80"
      description = "allowing http from the whole subnet"
      cidr        = "10.0.0.0/16"
    }
  ]
}

variable "vpc_id" {
  description = "This will be passed at the time of module calling as the vpc id"
  type        = string
}

variable "ingress_rules_wp-alb" {
  default = [
    {
      port = "443"
      cidr = "0.0.0.0/0"
    },
    {
      port = "80"
      cidr = "0.0.0.0/0"
    }
  ]
}