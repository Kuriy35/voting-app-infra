
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_id}-${var.env}-igw"
  }
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_cidr_blocks)

  vpc_id                  = var.vpc_id
  availability_zone       = element(var.availability_zones, count.index)
  cidr_block              = var.public_cidr_blocks[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_id}-${var.env}-public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_id}-${var.env}-public-rt"
  }
}

resource "aws_route" "public_route_to_igw" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_rt_association" {
  count = length(var.public_cidr_blocks)

  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_cidr_blocks)

  vpc_id            = var.vpc_id
  availability_zone = element(var.availability_zones, count.index)
  cidr_block        = var.private_cidr_blocks[count.index]

  tags = {
    Name = "${var.project_id}-${var.env}-private-subnet-${count.index + 1}"
  }
}

resource "aws_eip" "ngw_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project_id}-${var.env}-nat-eip"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${var.project_id}-${var.env}-nat-gateway"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_id}-${var.env}-private-rt"
  }
}

resource "aws_route" "private_route_to_ngw" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

resource "aws_route_table_association" "private_rt_association" {
  count = length(var.private_cidr_blocks)

  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}
