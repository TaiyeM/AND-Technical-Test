resource "aws_instance" "AND_ec2_webserver" {
  ami           = "ami-0cabc39acf991f4f1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.AND_sg.id]
  subnet_id =  element(aws_subnet.AND_public_subnets.*.id, count.index)
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
    description = "The EC2 webserver"
  }
}

resource "aws_lb" "AND_application_lb" {
  name               = "http-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.AND_sg.id]
  subnets            = aws_subnet.AND_public_subnets.*.id

    
  tags = {
    Name = "AND_application_lb"
    description = "The load balancer for the instances"
  }
}

resource "aws_lb_target_group" "AND_ALB_tg" {
  name     = "App-load-balancer-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.AND_VPC.id
  target_type = "instance"

  tags = {
    Name = "AND_application_lb_tg"
    description = "The load balancer target group"
  }
}
resource "aws_lb_target_group_attachment" "AND_tg_attachment" {
  count            = length(aws_instance.AND_ec2_webserver)
  target_group_arn = aws_lb_target_group.AND_ALB_tg.arn
  target_id        = aws_instance.AND_ec2_webserver[count.index].id     
  port             = 80
}


resource "aws_lb_listener" "AND_ALB_listener" {
  load_balancer_arn = aws_lb.AND_application_lb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.AND_ALB_tg.arn
  }
tags = {
    Name = "AND_ALB_listerner"
    description = "The load balancer target group listerner"
  }

}