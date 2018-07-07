## A Record
resource "aws_route53_record" "dev-jenkins-timdodev-com-A" {
  zone_id = "${aws_route53_zone.dev-domain-public.zone_id}"
  name    = "jenkins.timdodev.com"
  type    = "A"

  records = [
    "164.132.205.15",
  ]

  ttl = "1200"
}

resource "aws_route53_record" "dev-jenkins-timdodev-com-A" {
  zone_id = "${aws_route53_zone.dev-domain-public.zone_id}"
  name    = "jenkins.timdodev.com"
  type    = "A"

  records = [
    "${aws_instance.bastion.public_ip}",
  ]

  ttl = "1200"
}

## CNAME  Record
resource "aws_route53_record" "dev-jenkins-timdodev-com-CNAME" {
  zone_id = "${aws_route53_zone.dev-domain-public.zone_id}"
  name    = "status.timdodev.com"
  type    = "CNAME"

  records = [
    "uptime.statuscake.com/?TestID=Egz8fX7ACS",
  ]

  ttl = "60"
}

## SOA Record

resource "aws_route53_record" "dev-ssl-timdodev-com-TXT" {
  zone_id = "${aws_route53_zone.dev-domain-public.zone_id}"
  name    = "timdodev.com"
  type    = "TXT"

  records = [
    "ddddsdsdsdsdsds",
  ]

  ttl = "30"
}
