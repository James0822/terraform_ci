# 环境标识（如dev、prod）
variable "environment" {
  description = "Environment identifier (e.g. dev, prod)"
  type        = string
  default     = "dev"
}

# VPC CIDR块
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# 公有子网CIDR（2个可用区）
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# 私有应用子网CIDR（2个可用区）
variable "app_subnet_cidrs" {
  description = "List of CIDR blocks for application subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

# 私有数据子网CIDR（2个可用区，预留数据层）
variable "data_subnet_cidrs" {
  description = "List of CIDR blocks for data subnets"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

# 可用区列表
variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["ap-southeast-1", "ap-southeast-1"]
}



