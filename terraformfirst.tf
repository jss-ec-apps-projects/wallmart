provider "aws" {
  region     = "ap-south-1"
  access_key = var.access_key
  secret_key = var.secret_key
}
resource "aws_instance" "Awsserver"{
    ami ="ami-05ba3a39a75be1ec4"
    instance_type =var.instance_type
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]
    key_name="Jay"
    user_data = <<-EOF
                  #! /bin/bash
                  sudo apt-get update
                  sudo apt-get install -y apache2
                  sudo systemctl start apache2
                  sudo systemctl enable apache2
                  echo "The page was created by the user data" | sudo tee /var/www/html/index.html
                EOF

    tags ={
        Name= "terraform first instance"
    }
}
resource "aws_security_group" "instance" { 
   name        = "terraform -sercurity"
   description = "Allow TLS inbound traffic"
   ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


