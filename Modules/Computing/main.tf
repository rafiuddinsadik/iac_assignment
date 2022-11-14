# Webserver Instance
resource "aws_instance" "webserver" {
  ami           = "ami-0c4e4b4eb2e11d1d4"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"

  subnet_id                   = aws_subnet.webserver_subnet.id
  vpc_security_group_ids      = [aws_security_group.webserver_sg]
  associate_public_ip_address = true

  tags = {
    Name = "Webserver"
    Owner = "Rafi"
  }
}

# Generating KeyPair for Accessing DB
resource "tls_private_key" "dbkey" {
  algorithm = "RSA"
}
resource "local_file" "myterrakey" {
  content  = tls_private_key.dbkey.private_key_pem
  filename = "dbkp_tf.pem"
}
resource "aws_key_pair" "dbkp" {
  key_name   = "dbkp_tf"
  public_key = tls_private_key.dbkey.public_key_openssh
}

# DB Instance
resource "aws_instance" "db_server" {
  ami           = "ami-0c4e4b4eb2e11d1d4"
  instance_type = "t2.micro"
  availability_zone = "us-east-1b"

  subnet_id                   = aws_subnet.db_subnet.id
  vpc_security_group_ids      = [aws_security_group.webserver_sg]
  associate_public_ip_address = false

  key_name = aws_key_pair.dbkp.key_name

  tags = {
    Name = "DBserver"
    Owner = "Rafi"
  }
}