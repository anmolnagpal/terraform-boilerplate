variable "dev-var-db" {
  type = "map"

  default = {
    instance_count = 1

    #No of server's
    instance_type = "t2.medium"

    # Instace type
    volume_type           = "gp2"
    db_volume_size        = "15"
    db_ebs_size           = "50"
    delete_on_termination = false
  }
}

##____                                 _   _                ____
#/ ___|    ___    ___   _   _   _ __  (_) | |_   _   _     / ___|  _ __    ___    _   _   _ __
#\___ \   / _ \  / __| | | | | | '__| | | | __| | | | |   | |  _  | '__|  / _ \  | | | | | '_ \
##___) | |  __/ | (__  | |_| | | |    | | | |_  | |_| |   | |_| | | |    | (_) | | |_| | | |_) |
#|____/   \___|  \___|  \__,_| |_|    |_|  \__|  \__, |    \____| |_|     \___/   \__,_| | .__/
#

#db Security Group
resource "aws_security_group" "dev-sg-db" {
  name        = "${var.dev_vpc-main["env"]}-db"
  description = "db Security Group"

  lifecycle {
    create_before_destroy = true
  }

  #SSH access from VPC
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "${var.public_ip}",
    ]
  }

  #SSH access from VPC
  ingress {
    from_port = 27017
    to_port   = 27017
    protocol  = "tcp"

    cidr_blocks = [
      "${var.dev_vpc-main["cidr_block"]}",
    ]
  }

  #SSH access from VPC
  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"

    cidr_blocks = [
      "${var.dev_vpc-main["cidr_block"]}",
    ]
  }

  #Outbound internet access
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "${var.public_ip}",
    ]
  }

  vpc_id = "${var.dev_vpc-main["id"]}"

  tags {
    Name        = "${var.dev_vpc-main["env"]}-db"
    Environment = "${var.dev_vpc-main["env"]}"
  }
}

###_____    ____   ____
##| ____|  / ___| |___ \
##|  _|   | |       __) |
##| |___  | |___   / __/
##|_____|  \____| |_____|
##

#############################
#       db-AZ-A             #
#############################
resource "aws_instance" "dev-ec2-db" {
  ami                                  = "${var.ami["ubuntu_16_base"]}"
  instance_type                        = "${var.dev-var-db["instance_type"]}"
  count                                = "${var.dev-var-db["instance_count"]}"
  key_name                             = "${var.dev_vpc-base["key_name"]}"
  instance_initiated_shutdown_behavior = "stop"

  vpc_security_group_ids = [
    "${aws_security_group.dev-sg-db.id}",
  ]

  subnet_id = "${var.dev_subnet-app-1a-pub["id"]}"

  #Volume
  root_block_device {
    volume_type           = "${var.dev-var-db["volume_type"]}"
    volume_size           = "${var.dev-var-db["db_volume_size"]}"
    delete_on_termination = "${var.dev-var-db["delete_on_termination"]}"
  }

  tags {
    Name        = "${var.dev_vpc-main["env"]}-db-${count.index}-a"
    Environment = "${var.dev_vpc-main["env"]}"
  }

  volume_tags {
    Name        = "${var.dev_vpc-main["env"]}-db-${count.index}-a"
    Environment = "${var.dev_vpc-main["env"]}"
  }

  lifecycle {
    ignore_changes = [
      "ami",
      "source_dest_check",
      "instance_type",
      "root_block_device.0.delete_on_termination",
    ]
  }
}

##__     __   ___    _       _   _   __  __   _____
##\ \   / /  / _ \  | |     | | | | |  \/  | | ____|
###\ \ / /  | | | | | |     | | | | | |\/| | |  _|
####\ V /   | |_| | | |___  | |_| | | |  | | | |___
#####\_/     \___/  |_____|  \___/  |_|  |_| |_____|

resource "aws_ebs_volume" "dev-ebs-db" {
  count = "${var.dev-var-db["instance_count"]}"

  lifecycle {
    prevent_destroy = false
  }

  availability_zone = "${var.region}a"
  size              = "${var.dev-var-db["db_ebs_size"]}"
  type              = "gp2"

  tags {
    Name        = "${var.dev_vpc-main["env"]}-db-${count.index}-a"
    Environment = "${var.dev_vpc-main["env"]}"
  }
}

#ebs Attachment
resource "aws_volume_attachment" "dev-ebs-attachment" {
  device_name  = "/dev/sdf"
  count        = "${var.dev-var-db["instance_count"]}"
  volume_id    = "${element(aws_ebs_volume.dev-ebs-db.*.id, count.index)}"
  instance_id  = "${element(aws_instance.dev-ec2-db.*.id, count.index)}"
  force_detach = true
}

###___    _   _   _____   ____    _   _   _____
##/ _ \  | | | | |_   _| |  _ \  | | | | |_   _|
#| | | | | | | |   | |   | |_) | | | | |   | |
#| |_| | | |_| |   | |   |  __/  | |_| |   | |
##\___/   \___/    |_|   |_|      \___/    |_|

#Public IP
output "dev-output-db" {
  value = "${join("-", aws_instance.dev-ec2-db.*.private_ip)}"
}
