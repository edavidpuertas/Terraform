resource "aws_instance" "public_instance" {
    ami = "ami-0a3c3a20c09d6f377"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id
    key_name = data.aws_key_pair.key.key_name

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



