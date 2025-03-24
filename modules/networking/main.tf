resource "aws_vpc" "wp-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "wp-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.wp-vpc.id
  for_each                = var.public_subnet_cidr_blocks
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet-${each.key}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.wp-vpc.id
  for_each   = var.private_subnet_cidr_blocks
  cidr_block = each.value
  tags = {
    Name = "Private Subnet-${each.key}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.wp-vpc.id
  tags = {
    Name = "wp-igw"
  }
}

resource "aws_route_table" "wp-public-rt" {
  vpc_id     = aws_vpc.wp-vpc.id
  depends_on = [aws_internet_gateway.igw]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "wp-public-rt"
  }

}

resource "aws_route_table_association" "wp-public-rt-association" {
  depends_on     = [aws_route_table.wp-public-rt]
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.wp-public-rt.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "wp-nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet["1"].id

  tags = {
    Name = "wp-nat"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "wp-private-rt" {
  vpc_id     = aws_vpc.wp-vpc.id
  depends_on = [aws_nat_gateway.wp-nat]
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.wp-nat.id
  }
  tags = {
    Name = "wp-private-rt"
  }
}

resource "aws_route_table_association" "wp-private-rt-association" {
  for_each       = aws_subnet.private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.wp-private-rt.id
}