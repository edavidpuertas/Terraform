variable "virginia_cidr" {
  description = "CIDR Virginia"
  type        = string
  sensitive   = false


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
  type = list(string)
  
}