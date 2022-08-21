resource "aws_instance" "AND_ec2_webserver" {
  ami           = "ami-0cabc39acf991f4f1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.AND_sg.id]
  subnet_id = aws_subnet.AND_public_subnet.id
  count = 2
  user_data = <<EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd.x86_64
    systemctl start httpd.service
    systemctl enable httpd.service
    echo “Hello AND Digital from $(hostname -f)” > /var/www/html/index.html
  EOF
  
   tags = {
    Name = "AND_ec2_webserver"
  }
}