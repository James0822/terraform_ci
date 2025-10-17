# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

}

# 互联网网关（公有层访问互联网）
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

}

# 公有子网路由表
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

}

# 私有应用子网路由表（无互联网出口，如需NAT需额外配置）
resource "aws_route_table" "app_private" {
  vpc_id = aws_vpc.main.id
}

# 私有数据子网路由表（预留）
resource "aws_route_table" "data_private" {
  vpc_id = aws_vpc.main.id
}

# 公有子网（循环创建多可用区）
resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true  # 公有子网自动分配公网IP

}

# 私有应用子网
resource "aws_subnet" "app_private" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.app_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
}

# 私有数据子网（预留）
resource "aws_subnet" "data_private" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.data_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
}

# 公有子网路由表关联
resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# 私有应用子网路由表关联
resource "aws_route_table_association" "app_private" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.app_private[count.index].id
  route_table_id = aws_route_table.app_private.id
}

# 私有数据子网路由表关联
resource "aws_route_table_association" "data_private" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.data_private[count.index].id
  route_table_id = aws_route_table.data_private.id
}
