# Webserver Instance
resource "aws_instance" "webserver" {
  ami           = "${var.ami_id}"
  instance_type = "${var.ami_type}"
  availability_zone = "${var.webserver_az}"

  subnet_id                   = "${var.webserver_subnet_id}"
  vpc_security_group_ids      = "${var.webserver_secgrp_id}"
  associate_public_ip_address = true

  tags = {
    Name = "Webserver"
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
  ami           = "${var.ami_id}"
  instance_type = "${var.ami_type}"
  availability_zone = "${var.dbserver_az}"

  subnet_id                   = "${var.db_subnet_id}"
  vpc_security_group_ids      = "${var.db_secgrp_id}"
  associate_public_ip_address = false

  key_name = aws_key_pair.dbkp.key_name

  tags = {
    Name = "DBserver"
  }
}