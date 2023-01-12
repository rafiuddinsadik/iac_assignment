locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "source_ami" {
  ami_name      = "spring-${var.type}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0b0dcb5067f052a63"
  ssh_username  = "ec2-user"
  tags = {
    Name = "spring-${var.type}-${local.timestamp}"
  }
}

build {
  sources = ["source.amazon-ebs.source_ami"]

  provisioner "ansible" {
    playbook_file = "../Ansible/main-${var.type}.yml"
  }

}
