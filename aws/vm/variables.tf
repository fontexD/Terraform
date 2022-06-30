variable "region" {
default = "eu-north-1"
}
variable "instance_type" {
default = "t3.micro"
}
variable "profile_name" {
default = "default"
}
variable "instance_key" {
default = "MyKeyPair"
}
variable "vpc_cidr" {
default = "192.168.0.0/16"
}
variable "public_subnet_cidr" {
default = "192.168.10.0/24"
}
variable "private_subnet_cidr" {
default = "192.168.20.0/24"
}
variable "web-count" {
default = "3"
}
variable "haproxy-count" {
default = "1"
}