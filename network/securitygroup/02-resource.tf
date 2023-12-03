data "aws_region" "current" {}

### AWS Security Group
resource "aws_security_group" "default" {
  for_each    = { for scg in local.SecurityGroup_Optimize : scg.identifier => scg if length(local.SecurityGroup_Optimize) != 0 }
  vpc_id      = var.vpc_id[each.value.vpc_identifier]
  name        = join("-", ["scg", local.Share_Middle_Name, each.value.name_prefix])
  description = each.value.description
  tags = merge(each.value.tags, {
    "Name" = join("-", ["scg", local.Share_Middle_Name, each.value.name_prefix])
  })
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}