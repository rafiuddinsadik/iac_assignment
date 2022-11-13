# Webserver Instance
resource "aws_instance" "webserver" {
  ami           = "ami-0c4e4b4eb2e11d1d4"
  instance_type = "t2.micro"

  tags = {
    Name = "Webserver"
    Owner = "Rafi"
  }
}

# Webserver Instance
resource "aws_instance" "db_server" {
  ami           = "ami-0c4e4b4eb2e11d1d4"
  instance_type = "t2.micro"

  tags = {
    Name = "DBserver"
    Owner = "Rafi"
  }
}