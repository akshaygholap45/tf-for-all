# ==== VPC ==========
resource "aws_vpc" "m4l_vpc" {
  cidr_block           = "10.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "M4LVPC"
  }
}

# Internet gateway
resource "aws_internet_gateway" "m4l_igw" {
  vpc_id = aws_vpc.m4l_vpc.id
  tags = {
    Name = "M4L-IGW"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "RTPub" {
  vpc_id = aws_vpc.m4l_vpc.id
  tags = {
    Name = "M4L-vpc-rt-pub"
  }
}

resource "aws_route" "RTPub-IPv4" {
  route_table_id = aws_route_table.RTPub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.m4l_igw.id
  depends_on = [ aws_vpc.m4l_vpc ]
}

# Extract the Available AZ
data "aws_availability_zones" "available_AZ" {
  state = "available"
}

# =============== Public Subnets ==================

# ======= SNPUBA =============
resource "aws_subnet" "SNPUBA" {
  vpc_id = aws_vpc.m4l_vpc.id
  # depends_on = [ aws_route_table.RTPub ]
  availability_zone = data.aws_availability_zones.available_AZ.names[0]
  cidr_block = "10.16.48.0/20"
  map_public_ip_on_launch = true
  tags = {
    Name = "sn-pub-A"
  }
}
# Route table and Subnet association
resource "aws_route_table_association" "RTAssociationPubA" {
  route_table_id = aws_route_table.RTPub.id
  subnet_id = aws_subnet.SNPUBA.id
}

# ======= SNPUBB =============
resource "aws_subnet" "SNPUBB" {
  vpc_id = aws_vpc.m4l_vpc.id
  # depends_on = [ aws_route_table.RTPub ]
  availability_zone = data.aws_availability_zones.available_AZ.names[1]
  cidr_block = "10.16.112.0/20"
  map_public_ip_on_launch = true
  tags = {
    Name = "sn-pub-B"
  }
}
# Route table and Subnet association
resource "aws_route_table_association" "RTAssociationPubB" {
  route_table_id = aws_route_table.RTPub.id
  subnet_id = aws_subnet.SNPUBB.id
}

# ======= SNPUBC =============
resource "aws_subnet" "SNPUBC" {
  vpc_id = aws_vpc.m4l_vpc.id
  # depends_on = [ aws_route_table.RTPub ]
  availability_zone = data.aws_availability_zones.available_AZ.names[2]
  cidr_block = "10.16.176.0/20"
  map_public_ip_on_launch = true
  tags = {
    Name = "sn-pub-C"
  }
}
# Route table and Subnet association
resource "aws_route_table_association" "RTAssociationPubC" {
  route_table_id = aws_route_table.RTPub.id
  subnet_id = aws_subnet.SNPUBC.id
}

