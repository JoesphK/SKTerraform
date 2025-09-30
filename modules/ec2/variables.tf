variable "instances" {
  description = "Map of instances to create"
  type = map(object({
    ami            = string
    instance_type  = string
    subnet_id      = string
    sg_ids         = list(string)
  }))
}

variable "key_name" {
  type        = string
  description = "Key pair name"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}
