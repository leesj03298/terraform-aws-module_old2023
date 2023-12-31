#### Share Variable 
variable "Share_Middle_Name" {
    description = "Name Tags Middle Name(*Ex : join('-', ['vpc', var.Share_Middle_Name, each.value.name_prefix]))"
    type        = string
}

variable "sub_id" {
    type        = map(string)
}

variable "subnet_groups" {
    description = "Create Resource : Redshift Subnet Group"
    type    = list(object({
        identifier              = string
        name_prefix             = string
        sub_identifier          = optional(list(string), [null])
    }))
}

variable "parameter_groups" {
    description = "Create Resource : Redshift Parameter Group"
    type    = list(object({
        identifier              = string
        name_prefix             = string
        family                  = optional(string, "redshift-1.0")
    }))    
}