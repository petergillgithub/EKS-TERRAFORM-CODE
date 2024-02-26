resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = merge(var.comman_tags, {
    "Name" = "DEMO-VPC"
  })
}

resource "aws_subnet" "publicsubnet" {
  count                   = length(var.public_subnet)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.comman_tags, {
    "Name" = "Public-Subnets-${count.index + 1}"
  })

}

resource "aws_subnet" "privatesubnet" {
  count             = length(var.private_subnet)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.comman_tags, {
    "Name" = "Private-Subnets-${count.index + 1}"
  })

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.comman_tags, {
    "Name" = "Internet-Gate-way"
  })

}


resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.comman_tags, {
    "Name" = "public-RT-"
  })

}

resource "aws_route_table_association" "publicrtassociation" {
  count          = length(var.public_subnet)
  subnet_id      = element(aws_subnet.publicsubnet[*].id, count.index)
  route_table_id = aws_route_table.publicrt.id

}


resource "aws_eip" "elasticip" {
  count  = length(var.public_subnet)
  domain = "vpc"

  tags = merge(var.comman_tags, {
    "Name" = "Elastic-Ip-${count.index - 1}"
  })

}


resource "aws_nat_gateway" "nat-gateway" {
  count         = length(var.public_subnet)
  allocation_id = element(aws_eip.elasticip[*].id, count.index)
  subnet_id     = element(aws_subnet.publicsubnet[*].id, count.index)

  tags = merge(var.comman_tags, {
    "Name" = "Nat-Gateway-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "privatert" {
  count  = length(var.private_subnet)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat-gateway[*].id, count.index)
  }

  tags = merge(var.comman_tags, {
    "Name" = "private-RT-${count.index + 1}"
  })

}

resource "aws_route_table_association" "privatertassociation" {
  count          = length(var.private_subnet)
  subnet_id      = element(aws_subnet.privatesubnet[*].id, count.index)
  route_table_id = element(aws_route_table.privatert[*].id, count.index)

}

# AKIAV4QYMHNGG5I3D67O
# xgvw526iTMOzqExLUTqC8EhzARRHBDXa6exxYPvT