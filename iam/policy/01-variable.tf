#### Share Variable 
variable "Share_Middle_Name" {
  description = "Name Tags Middle Name(*Ex : join('-', ['vpc', var.Share_Middle_Name, each.value.name_prefix]))"
  type        = string
}

variable "policys" {
    type    = list(object({
        name_prefix             = string
        path                    = optional(string, "/")
        description             = optional(string, "Policy")
        policy                  = string
        tags                    = optional(map(string), null)
    }))
}

