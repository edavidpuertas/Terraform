variable "virginia_cidr" {
  description = "CIDR Virginia"
  type        = string
  #usin workspace
  #type        = map(string)


}
# ctrl + k + c comments line
# variable "public_subnet" {
#   description = "CIDR public subnet"
#   type        = string

# }

# variable "private_subnet" {
#   description = "CIDR private subnet"
#   type        = string

# }

variable "subnets" {
  description = "List of subnets"
  type        = list(string)

}

variable "tags" {
  description = "Tags del proyecto"
  type        = map(string)
}

variable "sg_igress_cidr" {
  description = "CIDR for ingress traffic"
  type        = string

}

variable "ec2_specs" {
  description = "Parametros de la instancia"
  type        = map(string)

}