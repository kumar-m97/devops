resource "aws_vpc" "vpc-1" {
    cidr_block = var.vpc-cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        name = var.vpc-name
    }
}

resources "aws_subnet" "public-subnet1" {
    cidr_block = var.public-subnet1-cidr
    vpc_id = aws_vpc.vpc-1.id
    availibility_zone = var.public-subnet1-az
    map_public_ip_on_launch = true

    tags = {
        name = var.public-subnet1-name
    }
}

resources "aws_internet_gateway" "ig-1" {
    vpc_id = aws_vpc.vpc-1.id

    tags = {
        Name = var.igw-name
    }
    depends_on = [aws_vpc.vpc-1]
}

resource "aws_subnet" "private-subnet1" {
    cidr_block = var.private-subnet1-cidr
    vpc_id = aws_vpc.vpc-1.id
    availibility_zone = var.private-subnet1-az
    map_public_ip_on_launch = false

    tags = {
        name = var.public-subnet1-name
    }
}

#Creating Elastic IP for NAT Gateway 1
resource "aws_eip" "eip1" {
  domain = "vpc"

  tags = {
    Name = var.eip-name1
  }
}

# Creating NAT Gateway 1
resource "aws_nat_gateway" "ngw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public-subnet1.id

  tags = {
    Name = var.ngw-name1
  }
}

#creating route table for public subnet 
resource "aws_route_table" "public-rt1" {
    vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associating the Public Route table 1 Public Subnet 1
resource "aws_route_table_association" "public-rt-association1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-rt1.id

  depends_on = [ aws_route_table.public-rt1 ]
}

# Creating Private Route table 1
resource "aws_route_table" "private-rt1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw1.id
  }

  tags = {
    Name = var.private-rt-name1
  }

  depends_on = [ aws_route_table_association.public-rt-association2 ]
}

# Associating the Private Route table 1 Private Subnet 1
resource "aws_route_table_association" "private-rt-association1" {
  subnet_id      = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.private-rt1.id

  depends_on = [ aws_route_table.private-rt1 ]
}

