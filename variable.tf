variable "AND_public_subnets_cidr" {
  description = "Number of AZ's"
  type = list(any)
  default = ["10.0.1.0/24","10.0.2.0/24"]

}
 