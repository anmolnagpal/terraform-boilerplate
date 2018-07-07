##____    ____     ___   __     __  ___   ____    _____   ____
#|  _ \  |  _ \   / _ \  \ \   / / |_ _| |  _ \  | ____| |  _ \
#| |_) | | |_) | | | | |  \ \ / /   | |  | | | | |  _|   | |_) |
#|  __/  |  _ <  | |_| |   \ V /    | |  | |_| | | |___  |  _ <
#|_|     |_| \_\  \___/     \_/    |___| |____/  |_____| |_| \_\
# Specify the provider and access details
provider "aws" {
  shared_credentials_file = "./../credentials.txt"
  profile                 = "dev"
  region                  = "${var.region}"
  alias                   = "dev"
}

provider "aws" {
  shared_credentials_file = "./../credentials.txt"
  profile                 = "stage"
  region                  = "${var.region}"
  alias                   = "stage"
}

provider "aws" {
  shared_credentials_file = "./../credentials.txt"
  profile                 = "live"
  region                  = "${var.region}"
  alias                   = "live"
}
