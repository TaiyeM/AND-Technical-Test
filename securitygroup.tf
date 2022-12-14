resource "aws_security_group" "AND_sg" {
  name        = "security group"
  description = "webserver security group"
  vpc_id      = aws_vpc.AND_VPC.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "AND_sg"
    description = "The Security group for the EC2 instances"
  }
}



