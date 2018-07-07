##__  __ ___ ____   ____     ____  _   _ ____  _   _ _____ _____
#|  \/  |_ _/ ___| / ___|   / ___|| | | | __ )| \ | | ____|_   _|
#| |\/| || |\___ \| |   ____\___ \| | | |  _ \|  \| |  _|   | |
#| |  | || | ___) | |__|_____|__) | |_| | |_) | |\  | |___  | |
#|_|  |_|___|____/ \____|   |____/ \___/|____/|_| \_|_____| |_|

# Subnet VPC
variable "dev-subnet-app-1a-pub" {
  type = "map"

  default = {
    cidr_block = "172.16.0.0/19"
  }
}

# Subnets with AZ-A
resource "aws_subnet" "dev-subnet-app-1a-pub" {
  vpc_id            = "${aws_vpc.dev-vpc-main.id}"
  cidr_block        = "${var.dev-subnet-app-1a-pub["cidr_block"]}"
  availability_zone = "${var.region}a"

  tags {
    Name        = "${var.dev_vpc-base["env"]}-subnet-app-1a-pub"
    Environment = "${var.dev_vpc-base["env"]}"
  }
}

##  route table association
resource "aws_route_table" "dev-rt-app-1a-pub" {
  vpc_id = "${aws_vpc.dev-vpc-main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.dev-internet-gateway.id}"
  }

  tags {
    Name        = "${var.dev_vpc-base["env"]}-rt-app-1a-pub"
    Environment = "${var.dev_vpc-base["env"]}"
  }
}

# route table association Zone-A
resource "aws_route_table_association" "dev-rt-app-1a-pub" {
  subnet_id      = "${aws_subnet.dev-subnet-app-1a-pub.id}"
  route_table_id = "${aws_route_table.dev-rt-app-1a-pub.id}"
}
