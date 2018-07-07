###_____   ___    _   _   _____
##|__  /  / _ \  | \ | | | ____|
####/ /  | | | | |  \| | |  _|
###/ /_  | |_| | | |\  | | |___
##/____|  \___/  |_| \_| |_____|

resource "aws_route53_zone" "name-io-public" {
  name    = "name.io"
  comment = "name"
}

###____    _____    ____    ___    ____    ____    ____
##|  _ \  | ____|  / ___|  / _ \  |  _ \  |  _ \  / ___|
##| |_) | |  _|   | |     | | | | | |_) | | | | | \___ \
##|  _ <  | |___  | |___  | |_| | |  _ <  | |_| |  ___) |
##|_| \_\ |_____|  \____|  \___/  |_| \_\ |____/  |____/

resource "aws_route53_record" "name-io-public-NS" {
  zone_id = "${aws_route53_zone.name-io-public.zone_id}"
  name    = "name.io"
  type    = "NS"

  records = [
    "ns-650.awsdns-17.net",
    "ns-1061.awsdns-04.org",
    "ns-403.awsdns-50.com",
    "ns-2037.awsdns-62.co.uk",
  ]

  ttl = "172800"
}

resource "aws_route53_record" "name-io-public-SOA" {
  zone_id = "${aws_route53_zone.name-io-public.zone_id}"
  name    = "name.io"
  type    = "SOA"

  records = [
    "ns-650.awsdns-17.net. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400",
  ]

  ttl = "900"
}
