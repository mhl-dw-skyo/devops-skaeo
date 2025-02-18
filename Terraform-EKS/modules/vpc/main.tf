# 1. create vpc
resource "aws_vpc" "vpc" {
   cidr_block = var.vpc_cidr
   enable_dns_hostnames = true
    tags = {
       Name = "skaeo-${var.env}-vpc"
    }
}

# 2. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id          =   aws_vpc.vpc.id
  depends_on = [
    aws_vpc.vpc
  ]
      tags = {
       Name = "skaeo-${var.env}-igw"
    }
}

#############################################################
###             PUBLIC SUBNET                           ####
#############################################################

# 3. create public subnet
resource "aws_subnet" "public" {
  count                     =   length(var.pub_subnet_cidr_list) 
  vpc_id                    =   aws_vpc.vpc.id
  cidr_block                =   element(var.pub_subnet_cidr_list, count.index)
  availability_zone         =   element(var.az_list_name, count.index)
  map_public_ip_on_launch   =   true

  tags =  {
        Name = "skaeo-${var.env}-public-subnet-${count.index + 1}"
        Tier = "Public"
        }
}

# create route table for attaching public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id        =   aws_vpc.vpc.id

  route {
    cidr_block  =   "0.0.0.0/0"
    gateway_id  =   aws_internet_gateway.igw.id
  }
  tags = {
      Name = "skaeo-${var.env}-public-routing-table"
      }
  lifecycle {
    ignore_changes = all
  }
}

# Attach route table to subnet
resource "aws_route_table_association" "public" {
  count          =  length(aws_subnet.public.*.id)
  subnet_id      =  aws_subnet.public[count.index].id
  route_table_id =  aws_route_table.public_route_table.id
}

#############################################################
###                PRIVATE SUBNET                      #####
#############################################################
# create elastic ip for nat gateway
resource "aws_eip" "nat" {
  domain                    = "vpc"
  tags = {
       Name = "skaeo-${var.env}-nat"
    }
}
# create nat gateway in each public subnet [ azs]
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  depends_on = [aws_internet_gateway.igw, aws_eip.nat]
}

resource "aws_subnet" "private" {
  count                     =   length(var.pri_subnet_cidr_list)
  vpc_id                    =   aws_vpc.vpc.id
  cidr_block                =   element(var.pri_subnet_cidr_list, count.index)
  availability_zone         =   element(var.az_list_name, count.index)
  map_public_ip_on_launch   =   false

  tags = {
        Name = "skaeo-${var.env}-private-subnet-${count.index + 1}"
        Tier = "Private"
        "karpenter.sh/discovery"  = local.eks_cluster_name
    }
}

# create route table for attaching private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id        =   aws_vpc.vpc.id
  route {
    cidr_block  =   "0.0.0.0/0"
    nat_gateway_id  =   aws_nat_gateway.nat.id
  }
  tags = {
      Name = "skaeo-${var.env}-private-routing-table"
      }
  lifecycle {
    ignore_changes = all
  }
  
}

# Attach route table to subnet
resource "aws_route_table_association" "private" {
  count          =  length(aws_subnet.private.*.id)
  subnet_id      =  element(aws_subnet.private.*.id, count.index)
  route_table_id =  aws_route_table.private_route_table.id
}
