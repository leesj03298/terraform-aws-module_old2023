
resource "aws_iam_policy" "default" {
    for_each    = { for policy in var.policys : join("-", ["iam", "policy", var.Share_Middle_Name, policy.name_prefix]) => policy } 
    name        = each.key
    path        = each.value.path
    description = each.value.description
    policy      = each.value.policy
    tags        = merge(each.value.tags, { "Name" = each.key })

}

