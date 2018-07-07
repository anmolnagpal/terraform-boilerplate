##__  __ ___ ____   ____     ____  _   _ ____  _   _ _____ _____
#|  \/  |_ _/ ___| / ___|   / ___|| | | | __ )| \ | | ____|_   _|
#| |\/| || |\___ \| |   ____\___ \| | | |  _ \|  \| |  _|   | |
#| |  | || | ___) | |__|_____|__) | |_| | |_) | |\  | |___  | |
#|_|  |_|___|____/ \____|   |____/ \___/|____/|_| \_|_____| |_|

# Subnet VPC
variable "dev-subnet-app-1b-prv" {
  type = "map"

  default = {
    cidr_block = "172.16.96.0/20"
  }
}

# Subnets with AZ-A
resource "aws_subnet" "dev-subnet-app-1b-prv" {
  vpc_id            = "${aws_vpc.dev-vpc-main.id}"
  cidr_block        = "${var.dev-subnet-app-1b-prv["cidr_block"]}"
  availability_zone = "${var.region}b"

  tags {
    Name        = "${var.dev_vpc-base["env"]}-subnet-app-1b-prv"
    Environment = "${var.dev_vpc-base["env"]}"
  }
}

##  route table association
resource "aws_route_table" "dev-rt-app-1b-prv" {
  vpc_id = "${aws_vpc.dev-vpc-main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.dev-internet-gateway.id}"
  }

  tags {
    Name        = "${var.dev_vpc-base["env"]}-rt-app-1b-prv"
    Environment = "${var.dev_vpc-base["env"]}"
  }
}

# route table association Zone-A
resource "aws_route_table_association" "dev-rt-app-1b-prv" {
  subnet_id      = "${aws_subnet.dev-subnet-app-1b-prv.id}"
  route_table_id = "${aws_route_table.dev-rt-app-1b-prv.id}"
}
