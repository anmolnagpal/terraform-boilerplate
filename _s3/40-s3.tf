resource "aws_s3_bucket" "dev-s3-hakunamatata" {
  bucket         = "${var.dev_vpc-base["env"]}-hakunamatata"
  region         = "${var.region}"
  acl            = "private"
  force_destroy  = "false"
  hosted_zone_id = ""

  versioning {
    enabled = true
  }

  tags {
    Name        = "${var.dev_vpc-base["env"]}-hakunamatata"
    Environment = "${var.dev_vpc-base["env"]}"
  }
}
