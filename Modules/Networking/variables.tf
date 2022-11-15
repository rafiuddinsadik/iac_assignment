variable "cidr_block" {
    default = "192.168.0.0/16"
}

variable "cidr_subnet_webserver" {
    default =  "192.168.1.0/24"
}

variable "cidr_subnet_db" {
    default =  "192.168.2.0/24"
}

variable "web_subnet_az" {
    default = "us-east-1a"
}

variable "db_subnet_az" {
    default = "us-east-1b"
}