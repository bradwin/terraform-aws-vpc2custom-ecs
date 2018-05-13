resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "main-vpc"
  }
}

# --- subnets ---

resource "aws_subnet" "public-subnet" {
  count                   = "${length(var.availability_zones)}"
  cidr_block              = "${var.public_subnets[count.index]}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.availability_zones[count.index]}"

  tags {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private-subnet" {
  count             = "${length(var.availability_zones)}"
  cidr_block        = "${var.private_subnets[count.index]}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${var.availability_zones[count.index]}"

  tags {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_subnet" "database-subnet" {
  count             = "${length(var.availability_zones)}"
  cidr_block        = "${var.database_subnets[count.index]}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${var.availability_zones[count.index]}"

  tags {
    Name = "database-subnet-${count.index}"
  }
}

# --- gateways ---

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "igw"
  }
}

resource "aws_eip" "ngw-eip" {
  vpc = "true"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.ngw-eip.id}"
  subnet_id     = "${element(aws_subnet.public-subnet.*.id, 0)}"

  tags {
    Name = "ngw"
  }
}

# --- routing tables ---
resource "aws_route_table" "public-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public-route-table-assoc" {
  count          = "${length(var.availability_zones)}"
  route_table_id = "${aws_route_table.public-route-table.id}"
  subnet_id      = "${element(aws_subnet.public-subnet.*.id, count.index)}"
}

resource "aws_route_table" "private-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "private-route-table"
  }
}

resource "aws_route" "private-route" {
  route_table_id         = "${aws_route_table.private-route-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.ngw.id}"
}

resource "aws_route_table_association" "private-route-table-assoc" {
  count          = "${length(var.availability_zones)}"
  route_table_id = "${aws_route_table.private-route-table.id}"
  subnet_id      = "${element(aws_subnet.private-subnet.*.id, count.index)}"
}

resource "aws_route_table_association" "database-route-table-assoc" {
  count          = "${length(var.availability_zones)}"
  route_table_id = "${aws_route_table.private-route-table.id}"
  subnet_id      = "${element(aws_subnet.database-subnet.*.id, count.index)}"
}
