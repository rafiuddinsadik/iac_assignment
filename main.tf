module "networking"{
    source = "./Modules/Networking"
}

module "computing"{
    source = "./Modules/Computing"

    webserver_subnet_id = "${module.networking.webserver_subnet_id}"
    db_subnet_id = "${module.networking.db_subnet_id}"
    webserver_secgrp_id = "${module.networking.webserver_secgrp_id}"
    db_secgrp_id = "${module.networking.webserver_subnet_id}"
}