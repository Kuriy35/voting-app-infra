resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = element(var.public_subnet_azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.project_id}-${var.env}-public-subnet-${count.index + 1}"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_id}-${var.env}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_id}-${var.env}-public-rt"
  }
}

resource "aws_route" "route_to_igw" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_rt_association" {
  count = length(aws_subnet.public_subnet)

  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}



resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = element(var.private_subnet_azs, count.index)

  tags = {
    Name                              = "${var.project_id}-${var.env}-private-subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project_id}-${var.env}-nat-eip"
  }
}

resource "aws_nat_gateway" "ngw" {
  #   count = length(aws_subnet.public_subnet)
  count = 1

  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "${var.project_id}-${var.env}-ngw-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_id}-${var.env}-private-rt"
  }
}

resource "aws_route" "route_to_nat" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw[0].id
}

resource "aws_route_table_association" "private_rt_association" {
  count = length(aws_subnet.private_subnet)

  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}
