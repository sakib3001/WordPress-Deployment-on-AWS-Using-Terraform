provider "aws" {
  region              = "us-east-1"
  shared_config_files = ["/home/sakib/.aws/credentials"]
}

resource "aws_security_group" "wp-server-sg" {
  name        = "wp-server-sg"
  description = "This is for the wp-servers in private subnet "
  vpc_id      = var.vpc_id # The value will be passed from the module calling 

  dynamic "ingress" {
    for_each = var.ingress_rules_wp-server
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value.cidr]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jumpbox-sg" {
  name        = "jumpbox-sg"
  description = "This is for jumpbox in public subnet"
  vpc_id      = var.vpc_id # The value will be passed from the module calling 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "This is allowing all ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "wp-alb-sg" {
  name        = "wp-alb-sg"
  description = "This is for the wp-alb-sg in public subnet "
  vpc_id      = var.vpc_id # The value will be passed from the module calling 
  dynamic "ingress" {
    for_each = var.ingress_rules_wp-alb
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value.cidr]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create a security group for RDS
resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Allow traffic from within the VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}