variable "dev-var-api" {
  type = "map"

  default = {
    #EC2-AZ-A
    a_instance_count = 1

    #EC2-AZ-B
    b_instance_count = 1

    #EC2-AZ-C
    c_instance_count = 0

    #No of server's
    instance_type = "t2.medium"

    # Instace type
    volume_type           = "gp2"
    volume_size           = "15"
    delete_on_termination = true
  }
}

##____                                 _   _                ____
#/ ___|    ___    ___   _   _   _ __  (_) | |_   _   _     / ___|  _ __    ___    _   _   _ __
#\___ \   / _ \  / __| | | | | | '__| | | | __| | | | |   | |  _  | '__|  / _ \  | | | | | '_ \
##___) | |  __/ | (__  | |_| | | |    | | | |_  | |_| |   | |_| | | |    | (_) | | |_| | | |_) |
#|____/   \___|  \___|  \__,_| |_|    |_|  \__|  \__, |    \____| |_|     \___/   \__,_| | .__/
#                                                 |___/                                  |_|

#Backend Security Group
resource "aws_security_group" "dev-sg-api" {
  name        = "${var.dev_vpc-main["env"]}-api"
  description = "Api Security Group"

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

  #PHP
  ingress {
    from_port = 9002
    to_port   = 9002
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
    Name        = "${var.dev_vpc-main["env"]}-api"
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
#        Backend-AZ-A       #
#############################

resource "aws_instance" "dev-ec2-api-a" {
  ami                                  = "${var.ami["ubuntu_16_base"]}"
  instance_type                        = "${var.dev-var-api["instance_type"]}"
  count                                = "${var.dev-var-api["a_instance_count"]}"
  key_name                             = "${var.dev_vpc-base["key_name"]}"
  instance_initiated_shutdown_behavior = "stop"

  vpc_security_group_ids = [
    "${aws_security_group.dev-sg-api.id}",
  ]

  subnet_id                   = "${var.dev_subnet-app-1a-pub["id"]}"
  associate_public_ip_address = true

  #Volume
  root_block_device {
    volume_type           = "${var.dev-var-api["volume_type"]}"
    volume_size           = "${var.dev-var-api["volume_size"]}"
    delete_on_termination = "${var.dev-var-api["delete_on_termination"]}"
  }

  tags {
    Name        = "${var.dev_vpc-main["env"]}-api-${count.index}-a"
    Environment = "${var.dev_vpc-main["env"]}"
  }

  volume_tags {
    Name        = "${var.dev_vpc-main["env"]}-api-${count.index}-a"
    Environment = "${var.dev_vpc-main["env"]}"
  }

  lifecycle {
    ignore_changes = [
      "ami",
      "ebs_optimized",
      "source_dest_check",
      "associate_public_ip_address",
      "instance_type",
      "root_block_device.0.delete_on_termination",
    ]
  }
}

#############################
#        Backend-AZ-B       #
#############################
resource "aws_instance" "dev-ec2-api-b" {
  ami                                  = "${var.ami["ubuntu_16_base"]}"
  instance_type                        = "${var.dev-var-api["instance_type"]}"
  count                                = "${var.dev-var-api["b_instance_count"]}"
  key_name                             = "${var.dev_vpc-base["key_name"]}"
  instance_initiated_shutdown_behavior = "stop"

  vpc_security_group_ids = [
    "${aws_security_group.dev-sg-api.id}",
  ]

  subnet_id = "${var.dev_subnet-app-1b-pub["id"]}"

  associate_public_ip_address = true

  #Volume
  root_block_device {
    volume_type           = "${var.dev-var-api["volume_type"]}"
    volume_size           = "${var.dev-var-api["volume_size"]}"
    delete_on_termination = "${var.dev-var-api["delete_on_termination"]}"
  }

  tags {
    Name        = "${var.dev_vpc-main["env"]}-api-${count.index}-b"
    Environment = "${var.dev_vpc-main["env"]}"
  }

  volume_tags {
    Name        = "${var.dev_vpc-main["env"]}-api-${count.index}-b"
    Environment = "${var.dev_vpc-main["env"]}"
  }

  lifecycle {
    ignore_changes = [
      "ami",
      "ebs_optimized",
      "source_dest_check",
      "associate_public_ip_address",
      "instance_type",
      "root_block_device.0.delete_on_termination",
    ]
  }
}

#############################
#        Backend-AZ-C       #
#############################
resource "aws_instance" "dev-ec2-api-c" {
  ami                                  = "${var.ami["ubuntu_16_base"]}"
  instance_type                        = "${var.dev-var-api["instance_type"]}"
  count                                = "${var.dev-var-api["c_instance_count"]}"
  key_name                             = "${var.dev_vpc-base["key_name"]}"
  instance_initiated_shutdown_behavior = "stop"

  vpc_security_group_ids = [
    "${aws_security_group.dev-sg-api.id}",
  ]

  subnet_id                   = "${var.dev_subnet-app-1c-pub["id"]}"
  associate_public_ip_address = true

  #Volume
  root_block_device {
    volume_type           = "${var.dev-var-api["volume_type"]}"
    volume_size           = "${var.dev-var-api["volume_size"]}"
    delete_on_termination = "${var.dev-var-api["delete_on_termination"]}"
  }

  tags {
    Name        = "${var.dev_vpc-main["env"]}-api-${count.index}-c"
    Environment = "${var.dev_vpc-main["env"]}"
  }

  volume_tags {
    Name        = "${var.dev_vpc-main["env"]}-api-${count.index}-c"
    Environment = "${var.dev_vpc-main["env"]}"
  }

  lifecycle {
    ignore_changes = [
      "ami",
      "ebs_optimized",
      "source_dest_check",
      "associate_public_ip_address",
      "instance_type",
      "root_block_device.0.delete_on_termination",
    ]
  }
}

###___    _   _   _____   ____    _   _   _____
##/ _ \  | | | | |_   _| |  _ \  | | | | |_   _|
#| | | | | | | |   | |   | |_) | | | | |   | |
#| |_| | | |_| |   | |   |  __/  | |_| |   | |
##\___/   \___/    |_|   |_|      \___/    |_|

#Public IP
output "dev-output-api" {
  value = [
    "${join("-", aws_instance.dev-ec2-api-a.*.private_ip)}",
    "${join("-", aws_instance.dev-ec2-api-b.*.private_ip)}",
    "${join("-", aws_instance.dev-ec2-api-c.*.private_ip)}",
  ]
}
