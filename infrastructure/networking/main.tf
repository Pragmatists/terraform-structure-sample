# VPC

resource "aws_vpc" "default" {
  cidr_block                       = "${var.vpc_cidr_block}"
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true

  tags {
    Name           = "${var.organization}"
    "organization" = "${var.organization}"
  }
}

# Internet Egress

resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    "organization" = "${var.organization}"
  }
}

# Routing

resource "aws_default_route_table" "main" {
  default_route_table_id = "${aws_vpc.default.default_route_table_id}"

  tags {
    Name           = "default"
    "organization" = "${var.organization}"
  }
}

resource "aws_route" "internet_gateway_ipv4" {
  route_table_id         = "${aws_default_route_table.main.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.public.id}"
}

resource "aws_route" "internet_gateway_ipv6" {
  route_table_id              = "${aws_default_route_table.main.id}"
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = "${aws_internet_gateway.public.id}"
}

# Subnets

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count             = "${length(data.aws_availability_zones.available.names)}"
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  cidr_block                      = "${cidrsubnet(aws_vpc.default.cidr_block, 4, count.index)}"
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.default.ipv6_cidr_block, 8, count.index)}"
  assign_ipv6_address_on_creation = true
  map_public_ip_on_launch         = true

  tags {
    "organization" = "${var.organization}"
  }

  lifecycle {
    ignore_changes = ["availability_zone"]
  }
}
