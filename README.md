# AND-Technical-Test
Resources required for the Solution to launch a load balanced webpage in AWS

I launched resources in a VPC, consisting of 2 public subnets, Internet gateway, route table, route table association and security group. The infrastructure includes 2 running instances in 2 availability zones.


The infrastructure consists of the following

1.	VPC
2.	Public subnets
3.	Internet gateway
4.	Route table
5.	Route table association to the public subnet
6.	Security group
7.	EC2 instance- consist of 2 running instances, and user data to launch the webserver
8.	Application load balancer, target group, listener and target group attachment
