# Creating a VPC
resource "aws_vpc" "main" {
  cidr_block       = "${var.cidr_block}"
  instance_tenancy = "default"

  tags = {
    Name = "Rafi Vpc"
  }
}

# Creating 2 subnets - Webserver & DB
resource "aws_subnet" "webserver_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.cidr_subnet_webserver}"
  availability_zone = "${var.web_subnet_az}"
  map_public_ip_on_launch = true

  tags = {
    Name = join(" - ", [var.cidr_subnet_webserver, "Webserver"])
  }
}

resource "aws_subnet" "db_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.cidr_subnet_db}"
  availability_zone = "${var.db_subnet_az}"

  tags = {
    Name = join(" - ", [var.cidr_subnet_db, "Database"])
  }
}

# Creating IG for public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
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

# Associating subnets to route tables
resource "aws_route_table_association" "webserver_to_ig" {
  subnet_id      = aws_subnet.webserver_subnet.id
  route_table_id = aws_route_table.ig_rt.id
}

# Creating Security Groups
resource "aws_security_group" "webserver_sg" {
  description = "Security Group for the webserver"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web_SG"
  }
}

resource "aws_security_group" "dbserver_sg" {
  description = "Security Group for the database server"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_subnet_webserver]
  }

  ingress {
    description      = "All ICMP ipv4"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = [var.cidr_subnet_webserver]
  }

  ingress {
    description      = "MYSQL/Aurora"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_subnet_webserver]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_subnet_webserver]
  }

  tags = {
    Name = "DB_SG"
  }
}