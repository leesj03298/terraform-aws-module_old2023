output "redshift_subnet_group" {
    value = aws_redshift_subnet_group.default[*]
}

output "Redshift_Parameter_Groups" {
    value = aws_redshift_parameter_group.default[*]
}