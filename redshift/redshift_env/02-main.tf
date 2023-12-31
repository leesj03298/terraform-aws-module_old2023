#### AWS Redshift Subnet Group ##################################################################################################
resource "aws_redshift_subnet_group" "default" {
    for_each        = { for subgrp in var.subnet_groups : subgrp.identifier => subgrp
    if subgrp.sub_identifier != null }
    name            = join("-", ["subgrp", var.Share_Middle_Name, each.value.name_prefix])
    subnet_ids      = [ for sub_identifier in each.value.sub_identifier : var.sub_id[ sub_identifier ] ]

}

#### AWS Redshift Parameter Group ###############################################################################################
resource "aws_redshift_parameter_group" "default" {
    for_each        = { for pargrp in var.parameter_groups : pargrp.identifier => pargrp }
    name            = join("-", ["pargrp", var.Share_Middle_Name, each.value.name_prefix])
    family          = each.value.family
}