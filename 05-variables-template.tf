##__     __     _      ____    ___      _      ____    _       _____   ____
##\ \   / /    / \    |  _ \  |_ _|    / \    | __ )  | |     | ____| / ___|
###\ \ / /    / _ \   | |_) |  | |    / _ \   |  _ \  | |     |  _|   \___ \
####\ V /    / ___ \  |  _ <   | |   / ___ \  | |_) | | |___  | |___   ___) |
#####\_/    /_/   \_\ |_| \_\ |___| /_/   \_\ |____/  |_____| |_____| |____/

variable "region" {
  default     = "eu-west-1"
  description = "Region Where you want to host"
}

variable "public_ip" {
  default = "0.0.0.0/0"
}

######
variable "ami" {
  type = "map"

  default = {
    ubuntu_16      = "ami-8fd760f6"
    ubuntu_16_base = "ami-8fd760f6"
    ubuntu_16_php  = "ami-8fd760f6"
  }
}

######
variable "dev_vpc-base" {
  type = "map"

  default = {
    env        = "dev"
    key_name   = "dev-it-admin-key"
    cidr_block = "172.16.0.0/16"
    name       = "dev-vpc"
  }
}

######
variable "stage_vpc-base" {
  type = "map"

  default = {
    env        = "stage"
    key_name   = "stage-it-admin-key"
    cidr_block = "192.168.0.0/16"
    name       = "stage-vpc"
  }
}

######
variable "live_vpc-base" {
  type = "map"

  default = {
    env        = "live"
    key_name   = "live-it-admin-key"
    cidr_block = "10.0.0.0/16"
    name       = "live-vpc"
  }
}

######

###### GENERATED ###### DO NOT REMOVE
