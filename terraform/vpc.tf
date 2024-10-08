
### vpc.tf
# vpc.tf
resource "aws_vpc" "shredder_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "shredder_subnet_public_1" {
  vpc_id                  = aws_vpc.shredder_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "shredder_subnet_private_1" {
  vpc_id            = aws_vpc.shredder_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "shredder_subnet_public_2" {
  vpc_id                  = aws_vpc.shredder_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "shredder_subnet_private_2" {
  vpc_id            = aws_vpc.shredder_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "shredder_igw" {
  vpc_id = aws_vpc.shredder_vpc.id
}

resource "aws_route_table" "shredder_public_rt" {
  vpc_id = aws_vpc.shredder_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.shredder_igw.id
  }
}

resource "aws_route_table_association" "shredder_public_rt_assoc_1" {
  subnet_id      = aws_subnet.shredder_subnet_public_1.id
  route_table_id = aws_route_table.shredder_public_rt.id
}

resource "aws_route_table_association" "shredder_public_rt_assoc_2" {
  subnet_id      = aws_subnet.shredder_subnet_public_2.id
  route_table_id = aws_route_table.shredder_public_rt.id
}
