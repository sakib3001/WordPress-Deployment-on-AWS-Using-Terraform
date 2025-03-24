variable "security_groups" {
  description = "List of security group IDs for ALB"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for ALB"
  type        = list(string)
}

variable "target_ids" {
  description = "List of instance IDs to attach to ALB"
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}
