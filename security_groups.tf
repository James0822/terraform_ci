# 公有层安全组（如负载均衡器）
resource "aws_security_group" "public_layer" {
  name        = "${var.environment}-public-layer-sg"
  description = "Allow HTTP/HTTPS from internet"
  vpc_id      = aws_vpc.main.id

  # 允许互联网访问80/443端口
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 允许所有出站流量
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-public-layer-sg"
  })
}

# 应用层安全组（仅允许来自公有层的流量）
resource "aws_security_group" "app_layer" {
  name        = "${var.environment}-app-layer-sg"
  description = "Allow traffic from public layer"
  vpc_id      = aws_vpc.main.id

  # 允许来自公有层安全组的应用端口（示例8080）
  ingress {
    description     = "App traffic from public layer"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.public_layer.id]
  }

  # 允许所有出站流量
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-app-layer-sg"
  })
}

# 数据层安全组（预留，仅允许来自应用层的流量）
resource "aws_security_group" "data_layer" {
  name        = "${var.environment}-data-layer-sg"
  description = "Allow traffic from app layer"
  vpc_id      = aws_vpc.main.id

  # 允许来自应用层安全组的自定义端口（示例3306）
  ingress {
    description     = "Data traffic from app layer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_layer.id]
  }

  # 允许所有出站流量
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-data-layer-sg"
  })
}