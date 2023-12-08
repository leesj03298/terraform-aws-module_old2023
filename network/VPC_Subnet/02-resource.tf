data "aws_region" "current" {}

### AWS VPC
resource "aws_vpc" "default" {
  for_each             = { for vpc in var.vpcs : vpc.identifier => vpc }
  cidr_block           = each.value.cidr_block
  enable_dns_hostnames = each.value.enable_dns_hostnames
  enable_dns_support   = each.value.enable_dns_support
  instance_tenancy     = each.value.instance_tenancy
  tags = merge(each.value.tags, {
    "Name" = join("-", ["vpc", var.Share_Middle_Name, each.value.name_prefix])
  })
}

locals {
  vpc_id = { for key, vpc in aws_vpc.default : key => vpc.id if length(aws_vpc.default) != 0 }
}

### AWS Internet Gateway 
resource "aws_internet_gateway" "default" {
  for_each = { for igw in var.vpcs : igw.identifier => igw
  if alltrue([igw.igw_enable, length(aws_vpc.default) != 0]) }
  vpc_id = local.vpc_id[each.key]
  tags = merge(each.value.tags, {
    "Name" = join("-", ["igw", var.Share_Middle_Name, each.value.name_prefix])
  })
}

### AWS Subnet
resource "aws_subnet" "default" {
  for_each = { for sub in var.subnets : sub.identifier => sub
  if length(aws_vpc.default) != 0 }
  vpc_id            = local.vpc_id[each.value.vpc_identifier]
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block
  tags = merge(each.value.tags, {
    "Name" = join("-", ["sub", var.Share_Middle_Name, each.value.name_prefix])
  })
}

locals {
  subnet_id = { for key, subnet in aws_subnet.default : key => subnet.id if length(aws_subnet.default) != 0 }
}

### AWS Route Table 
resource "aws_route_table" "default" {
  for_each = { for rtb in var.route_tables : rtb.identifier => rtb
  if length(aws_vpc.default) != 0 }
  vpc_id = local.vpc_id[each.value.vpc_identifier]
  tags = merge(each.value.tags, {
    "Name" = join("-", ["rtb", var.Share_Middle_Name, each.value.name_prefix])
  })
}
locals {
  route_table_id = { for key, route_table in aws_route_table.default : key => route_table.id if length(aws_route_table.default) != 0 }
}

### AWS Route Table Assocation Subnet
resource "aws_route_table_association" "default" {
  for_each = { for sub in var.subnets : join("-", [sub.identifier, sub.route_table_identifier]) => sub
  if length(aws_route_table.default) != 0 }
  route_table_id = local.route_table_id[each.value.route_table_identifier]
  subnet_id      = local.subnet_id[each.value.identifier]
}