resource "aws_eip" "nginx_a" {
  //count = "${length(aws_instance.nginx_a.*.public_ip)}"
  count    = "${var.dev-var-loadbalancer["a_instance_count"]}"
  instance = "${element(aws_instance.dev-ec2-loadbalancer-a.*.id, count.index)}"
  vpc      = true
}

resource "aws_eip" "nginx_b" {
  //count = "${length(aws_instance.nginx_b.*.public_ip)}"
  count    = "${var.dev-var-loadbalancer["b_instance_count"]}"
  instance = "${element(aws_instance.dev-ec2-loadbalancer-b.*.id, count.index)}"
  vpc      = true
}

resource "aws_eip" "nginx_c" {
  //count = "${length(aws_instance.nginx_c.*.public_ip)}"
  count    = "${var.dev-var-loadbalancer["c_instance_count"]}"
  instance = "${element(aws_instance.dev-ec2-loadbalancer-c.*.id, count.index)}"
  vpc      = true
}
