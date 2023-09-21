resource "aws_vpc" "bot_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
}

resource "aws_subnet" "bot_subnet" {
  vpc_id                  = aws_vpc.bot_vpc.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.subnet_az
}

resource "aws_internet_gateway" "bot_internet_gateway" {
  vpc_id = aws_vpc.bot_vpc.id
}

resource "aws_route_table" "bot_public_rt" {
  vpc_id = aws_vpc.bot_vpc.id
}

resource "aws_route" "bot_route" {
  route_table_id         = aws_route_table.bot_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.bot_internet_gateway.id
}

resource "aws_route_table_association" "bot_public_assoc" {
  subnet_id      = aws_subnet.bot_subnet.id
  route_table_id = aws_route_table.bot_public_rt.id
}