resource "aws_instance" "public_instance" {
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = file("scripts/user_data.sh")
  #  user_data = <<-EOF
  #    #!/bin/bash
  #    echo "This is a message" > ~/mensaje.txt
  # EOF

  # #when it is created
  #   provisioner "local-exec" {
  #     command = "echo instance created with IP${aws_instance.public_instance.public_ip} >> data_instance.txt"

  # #   }
  # # when it is destroyed
  #   provisioner "local-exec" {
  #     when = destroy

  #     command = "echo instance ${self.public_ip} destroyed >> data_instance_destroyed.txt"

  #   }

  #   provisioner "remote-exec" {
  #     inline = [ 
  #       "echo 'hola mundo' > ~/saludo.txt"
  #      ]

  #   }

  #   connection {
  #     type = "ssh"
  #     host = self.public_ip
  #     user = "ec2-user"
  #     private_key = file("/mnt/c/Users/epuertas/Documents/Terraform_AWS_LAB/mykeytf.pem")

  #   }

  # lifecycle {
  #     #First create instance and after destroy the instance
  #   create_before_destroy = true
  # }

  #   lifecycle {
  #Prevent destroy resource
  #     prevent_destroy = true
  #   }

  # lifecycle {
  #   ignore_changes = [ 
  #     ami,
  #     subnet_id
  #    ]
  # }

  #     lifecycle {
  #       replace_triggered_by = [ 
  #         aws_subnet.private_subnet ]
  # # Replace the instance if the subnet is changed
  #     }

}




