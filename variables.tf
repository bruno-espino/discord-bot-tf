variable "vpc_cidr_block" {
  type    = string
  default = "10.123.0.0/16"
}

variable "subnet_cidr_block" {
  type    = string
  default = "10.123.1.0/24"
}

variable "subnet_az" {
  default = "us-east-1a"
}