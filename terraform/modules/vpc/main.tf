resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = { Name = "${var.project}-vpc" }
}

resource "aws_subnet" "public" {
  for_each = toset(var.public_subnets)
  vpc_id   = aws_vpc.this.id
  cidr_block = each.key
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, index(var.public_subnets, each.key))
  tags = { Name = "${var.project}-public-${each.key}" }
}

resource "aws_subnet" "private" {
  for_each = toset(var.private_subnets)
  vpc_id   = aws_vpc.this.id
  cidr_block = each.key
  availability_zone = element(data.aws_availability_zones.available.names, index(var.private_subnets, each.key))
  tags = { Name = "${var.project}-private-${each.key}" }
}

output "vpc_id" { value = aws_vpc.this.id }
output "public_subnets" { value = [for s in aws_subnet.public : s.id] }
output "private_subnets" { value = [for s in aws_subnet.private : s.id] }

data "aws_availability_zones" "available" {}
