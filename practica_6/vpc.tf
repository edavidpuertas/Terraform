resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    Name = "vpc_virginia"
  }
  # tags = {
  #   Name = "VPC_VIRGINIA"
  #   name = "prueba"
  #   env  = "Dev"
  # }

}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_virginia.id
  #cidr_block              = var.public_subnet
  cidr_block              = var.subnets[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
#   tags = {
#     Name = "Public Subnet"
#     name = "prueba"
#     env  = "Dev"
# }

}
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_virginia.id
  #cidr_block              = var.private_subnet
  cidr_block = var.subnets[1]
  tags = {
    Name = "private_subenet"
  }
#   tags = {
#     Name = "Private Subnet"
#     name = "prueba"
#     env  = "Dev"
# }
  depends_on = [
    aws_subnet.public_subnet
   ]
}