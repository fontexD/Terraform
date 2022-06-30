terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
  profile = var.profile_name
}

# Create a VPC, vpc is the virtual private cloud which isolates your workloads, and gives you the otion to define the inbound/outbound access, you can even definde hybrid-solutions
resource "aws_vpc" "app_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "app-vpc"
  }
}
# Create the gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "vpc_igw"
  }
}

# elastic ip for the gateway
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

# Nat gateway for the private subnets
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "nat"
  }
}
# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                                      = aws_vpc.app_vpc.id
  cidr_block                                  = var.public_subnet_cidr
  map_public_ip_on_launch                     = true
  availability_zone                           = "eu-north-1a"
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet"

  }
}

# Private subnets route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.app_vpc.id 
  
  tags = {
    NameS = "private-route-table"
  }
}

# Public subnets route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "public_rt"
  }
}

# Add route for public route table to internet gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Add route for private route table to nat gateway
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}


# Associate the public route table to private subnets
resource "aws_route_table_association" "private_rt" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
# Associate the public route table to public subnets
resource "aws_route_table_association" "public_rt" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

#Create secruity group for the Subnets/instances
resource "aws_security_group" "sg" {
  name        = "allow_ssh_http"
  description = "Allow ssh http inbound traffic"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    self             = true
  }

    ingress {
    description      = "HTTPs from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    self             = true
  }
    ingress {
    description      = "HTTP stats haproxy from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    self             = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    self             = true
  }

  tags = {
    Name = "allow_ssh_http"
  }

}

# This is the creation of the actual VM in aws
resource "aws_instance" "web" {
  depends_on = [
    aws_nat_gateway.nat
  ]
  count                 = var.web-count
  ami                   = "ami-0440e5026412ff23f" #what image to create the vm off (can be listet via cli or ec2 console @ launch instanse in the gui console)
  instance_type         = var.instance_type # what machine do you want, can be listed same place 
  key_name              = var.instance_key #ssh key-name in ec2
  subnet_id             = aws_subnet.private_subnet.id #public subnet
  security_groups       = [aws_security_group.sg.id] #security-group for this
  #cloud-init what to do while creating the vm
  user_data = <<-EOF
  #!/bin/bash
  sudo apt install apache2 -y
  sudo apt update -y
  echo "Web-server opsat for Cloud-forlob aarhus-tech! Af Ronny Fonvig 06-27-2022 Hostname - $HOSTNAME" > /var/www/html/index.html
  EOF
  tags = {
    Name = "web_instance-${count.index + 1}"
  }

  volume_tags = {
    Name = "web_instance-${count.index + 1}"
  } 
}
resource "aws_instance" "haproxy" {
  depends_on = [
    aws_instance.web
  ]
  count                 = var.haproxy-count
  ami                   = "ami-0440e5026412ff23f" #what image to create the vm off (can be listet via cli or ec2 console @ launch instanse in the gui console)
  instance_type         = var.instance_type # what machine do you want, can be listed same place 
  key_name              = var.instance_key #ssh key-name in ec2
  subnet_id             = aws_subnet.public_subnet.id #public subnet
  security_groups       = [aws_security_group.sg.id] #security-group for this
  #cloud-init what to do while creating the vm
  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing haproxy"
  sudo apt update -y
  sudo apt install haproxy -y
  echo "*** Completed Installing haproxy"
  EOF
  tags = {
    Name = "haproxy_instance-${count.index + 1}"
  }

  volume_tags = {
    Name = "haproxys_instance-${count.index + 1}"
  } 
}

# Generate config file for haproxy
resource "local_file" "web_servers_ip" {
  depends_on = [
    aws_instance.web
  ]
  
  content = templatefile("${path.module}/templates/haproxy.tftpl",
    {
      web_servers_ip = aws_instance.web.*.private_ip
      web_servers_id = aws_instance.web.*.id

      }
  )
  filename = "./ansible/haproxy.cfg"
} 

resource "local_file" "haproxy_ip" {
  depends_on = [
    aws_instance.haproxy
  ]
  
  content = templatefile("${path.module}/templates/hosts.tftpl",
    {
      haproxy_ip = aws_instance.haproxy.*.public_ip
      haproxy_id = aws_instance.haproxy.*.id

      }
  )
  filename = "./ansible/hosts.cfg"
}

resource "null_resource" "Run_ansible" {
  depends_on = [aws_instance.haproxy]
  provisioner "local-exec" {
    command = "ansible-playbook -i ./ansible/hosts.cfg ./ansible/main.yaml --ssh-common-args='-o StrictHostKeyChecking=no'"
  }

  }
