##___    ____  __        __
#|_ _|  / ___| \ \      / /
##| |  | |  _   \ \ /\ / /
##| |  | |_| |   \ V  V /
#|___|  \____|    \_/\_/

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "dev-internet-gateway" {
  vpc_id = "${aws_vpc.dev-vpc-main.id}"

  tags {
    Name        = "${var.dev_vpc-base["env"]}-igw"
    Environment = "${var.dev_vpc-base["env"]}"
  }
}
