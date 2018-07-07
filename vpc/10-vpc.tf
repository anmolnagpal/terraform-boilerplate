#__     __  ____     ____
#\ \   / / |  _ \   / ___|
##\ \ / /  | |_) | | |
###\ V /   |  __/  | |___
####\_/    |_|      \____|

# Create a VPC to launch our instances into
resource "aws_vpc" "dev-vpc-main" {
  cidr_block           = "${var.dev_vpc-base["cidr_block"]}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name        = "${var.dev_vpc-base["name"]}"
    Environment = "${var.dev_vpc-base["env"]}"
  }
}
