output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "public_subnet_ids" {
  value = "${aws_subnet.public.*.id}"
}

output "default_route_table_id" {
  value = "${aws_default_route_table.main.id}"
}
