resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  # cidr_block = lookup(var.virginia_cidr,terraform.workspace)
  tags = {
    Name = "vpc_virginia-${local.sufix}"
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
    Name = "public_subnet-${local.sufix}"
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
    Name = "private_subenet-${local.sufix}"
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
    Name = "igw vpc virginia-${local.sufix}"
  }
}

resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.vpc_virginia.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_crt-${local.sufix}"
  }
}

resource "aws_route_table_association" "crta_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id
}

resource "aws_security_group" "sg_public_instance" {
  name        = "Public Instance SG-${local.sufix}"
  description = "Allow SSH inbound traffic and all egress traffic"
  vpc_id      = aws_vpc.vpc_virginia.id

  dynamic "ingress" {
    for_each = var.ingress_port_list
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.sg_igress_cidr]
    }

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "Public Intance SG-${local.sufix}"
  }
}

module "mybucket" {
  source = "./modulos/s3"
  bucket_name = "nombre12345678"
}

output "s3_arn" {
  
  value = module.mybucket.s3_bucket_arn
}

#  module "terraform_state_backend" {
#      source = "cloudposse/tfstate-backend/aws"
#      # Cloud Posse recommends pinning every module to a specific version
#      version     = "0.38.1"
#      namespace  = "example"
#      stage      = "prod"
#      name       = "terraform"
#      attributes = ["state"]

#      terraform_backend_config_file_path = "."
#      terraform_backend_config_file_name = "backend.tf"
#      force_destroy                      = false
#    }