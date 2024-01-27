resource "aws_instance" "public_instance" {
    ami = "ami-0a3c3a20c09d6f377"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id
  
}

