variable "webserver_subnet_id" {}

variable "db_subnet_id" {}

variable "webserver_secgrp_id" {}

variable "db_secgrp_id" {}

variable "ami_id" {
    default = "ami-0c4e4b4eb2e11d1d4"
}

variable "ami_type" {
    default = "t2.micro"
}

variable "webserver_az" {
    default = "us-east-1a"
}

variable "dbserver_az" {
    default = "us-east-1b"
}