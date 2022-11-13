# Creating a VPC
resource "aws_vpc" "main" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Rafi Vpc"
    Owner = "Rafi"
  }
}

# Creating 2 subnets - Webserver & DB
resource "aws_subnet" "webserver_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "192.168.1.0/24 - Webserver"
  }
}

resource "aws_subnet" "db_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "192.168.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "192.168.2.0/24 - Database"
  }
}

# Creating IG for public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
    Owner = "Rafi"
  }
}

# Creating Route Table for IGW
resource "aws_route_table" "ig_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "MyInternetRT"
  }
}

resource "aws_route_table_association" "webserver_to_ig" {
  subnet_id      = aws_subnet.webserver_subnet.id
  route_table_id = aws_route_table.ig_rt.id
}