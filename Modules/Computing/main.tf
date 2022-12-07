# Fetch AMI id(s)
data "aws_ami" "web_ami" {
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "tag:Name"
    values = ["spring-web-*"]
  }
  owners      = ["self"]
  most_recent = true
}

data "aws_ami" "db_ami" {
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "tag:Name"
    values = ["spring-db-*"]
  }
  owners      = ["self"]
  most_recent = true
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

# Launch Template Configuration
resource "aws_launch_template" "webserver-template" {
  image_id                             = data.aws_ami.web_ami.id
  instance_type                        = var.ami_type
  vpc_security_group_ids               = [var.webserver_secgrp_id]
  
  placement {
    availability_zone = var.webserver_az
  }

  tags = {
    Name = "Webserver"
  }
}

resource "aws_launch_template" "dbserver-template" {
  image_id                             = data.aws_ami.db_ami.id
  instance_type                        = var.ami_type
  vpc_security_group_ids               = [var.db_secgrp_id]
  key_name = aws_key_pair.dbkp.key_name
  
  placement {
    availability_zone = var.dbserver_az
  }
  
  tags = {
    Name = "DBserver"
  }
}

# Auto Scaling Group Configuration
resource "aws_autoscaling_group" "web_asg" {
  vpc_zone_identifier       = [var.webserver_subnet_id]

  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.webserver-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Webserver-spring"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "db_asg" {
  vpc_zone_identifier       = [var.db_subnet_id]

  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.dbserver-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "DBserver-mysql"
    propagate_at_launch = true
  }
}