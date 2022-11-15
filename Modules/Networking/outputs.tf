output "webserver_subnet_id" {
    value = "${aws_subnet.webserver_subnet.id}"
}

output "db_subnet_id" {
    value = "${aws_subnet.db_subnet.id}"
}

output "webserver_secgrp_id" {
    value = "${aws_security_group.webserver_sg.id}"
}

output "db_secgrp_id" {
    value = "${aws_security_group.dbserver_sg.id}"
}