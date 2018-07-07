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

variable "dev_internet-gateway" {
  type = "map"

  default = {
    env = "dev"
    id  = "igw-23b01244"
  }
}

variable "dev_subnet-app-1a-prv" {
  type = "map"

  default = {
    availability_zone = "eu-west-1a"
    cidr_block        = "172.16.32.0/20"
    env               = "dev"
    id                = "subnet-92f3eef5"
    vpc_cidr_block    = "172.16.0.0/16"
  }
}

variable "dev_subnet-app-1a-pub" {
  type = "map"

  default = {
    availability_zone = "eu-west-1a"
    cidr_block        = "172.16.0.0/19"
    env               = "dev"
    id                = "subnet-b3f0edd4"
    vpc_cidr_block    = "172.16.0.0/16"
  }
}

variable "dev_subnet-app-1b-prv" {
  type = "map"

  default = {
    availability_zone = "eu-west-1b"
    cidr_block        = "172.16.96.0/20"
    env               = "dev"
    id                = "subnet-8a48a9c2"
    vpc_cidr_block    = "172.16.0.0/16"
  }
}

variable "dev_subnet-app-1b-pub" {
  type = "map"

  default = {
    availability_zone = "eu-west-1b"
    cidr_block        = "172.16.64.0/19"
    env               = "dev"
    id                = "subnet-a44baaec"
    vpc_cidr_block    = "172.16.0.0/16"
  }
}

variable "dev_subnet-app-1c-prv" {
  type = "map"

  default = {
    availability_zone = "eu-west-1c"
    cidr_block        = "172.16.160.0/20"
    env               = "dev"
    id                = "subnet-5431680f"
    vpc_cidr_block    = "172.16.0.0/16"
  }
}

variable "dev_subnet-app-1c-pub" {
  type = "map"

  default = {
    availability_zone = "eu-west-1c"
    cidr_block        = "172.16.128.0/19"
    env               = "dev"
    id                = "subnet-bf3f66e4"
    vpc_cidr_block    = "172.16.0.0/16"
  }
}

variable "dev_subnet-app-1spr-prv" {
  type = "map"

  default = {
    availability_zone = "eu-west-1a"
    cidr_block        = "172.16.224.0/20"
    env               = "dev"
    id                = "subnet-9af4e9fd"
    vpc_cidr_block    = "172.16.0.0/16"
  }
}

variable "dev_subnet-app-1spr-pub" {
  type = "map"

  default = {
    availability_zone = "eu-west-1a"
    cidr_block        = "172.16.192.0/19"
    env               = "dev"
    id                = "subnet-87fce1e0"
    vpc_cidr_block    = "172.16.0.0/16"
  }
}

variable "dev_vpc-main" {
  type = "map"

  default = {
    cidr_block = "172.16.0.0/16"
    env        = "dev"
    id         = "vpc-a68073c0"
  }
}
