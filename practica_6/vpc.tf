resource "aws_vpc" "vpc_virginia" {
   cidr_block = var.virginia_cidr
 # cidr_block = lookup(var.virginia_cidr,terraform.workspace)
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
  vpc_id = aws_vpc.vpc_virginia.id
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
  vpc_id = aws_vpc.vpc_virginia.id
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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_virginia.id

  tags = {
    Name = "igw vpc virginia"
  }
}

resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.vpc_virginia.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_crt"
  }
}

resource "aws_route_table_association" "crta_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id
}

resource "aws_security_group" "sg_public_instance" {
  name        = "Public Instance SG"
  description = "Allow SSH inbound traffic and all egress traffic"
  vpc_id      = aws_vpc.vpc_virginia.id

  ingress {
    description = "SSH over internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.sg_igress_cidr]


  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "Public Intance SG"
  }
}

