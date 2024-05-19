#This Terraform Code Deploys Basic VPC Infra.
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_vpc" "my-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name  = "${var.vpc_name}"
    Owner = "bhavsingh"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "${var.IGW_name}"
  }
}

#create public subnets
resource "aws_subnet" "subnet1-public" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.public_subnet1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.public_subnet1_name}"
  }
}

resource "aws_subnet" "subnet2-public" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.public_subnet2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.public_subnet2_name}"
  }
}


# Create Application Private Subnet

resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.private_subnet1_name}"
  }
}

#Route table for public subnet

resource "aws_route_table" "terraform-public" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.Main_Routing_Table}"
  }
}

resource "aws_route_table_association" "terraform-public" {
  subnet_id      = aws_subnet.subnet1-public.id
  route_table_id = aws_route_table.terraform-public.id
}

# Route table for private subnet

resource "aws_route_table" "terraform-private" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_nat_gw.id
  }

  tags = {
    Name = "${var.private_Routing_Table}"
  }
}

resource "aws_route_table_association" "terraform-private" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.terraform-private.id
}

#creation of NAT gateway
resource "aws_nat_gateway" "public_nat_gw" {
  subnet_id         = aws_subnet.subnet1-public.id
  allocation_id     = aws_eip.nat.id
  connectivity_type = "public"
  tags = {
    Name = "Public NAT-GW"
  }
}
#create EIP
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "my-EIP"
  }
}


#Create EC2 Instance public
resource "aws_instance" "web-1" {
  ami                    = "ami-04b70fa74e45c3917"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  key_name               = "LaptopKey"
  vpc_security_group_ids = [aws_security_group.my_security_group1.id]
  subnet_id              = aws_subnet.subnet1-public.id

  tags = {
    Name = "Web Server-1"
  }
}

#create EC2 instance private

resource "aws_instance" "web-2" {
  ami                    = "ami-04b70fa74e45c3917"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1c"
  key_name               = "LaptopKey"
  vpc_security_group_ids = [aws_security_group.my_security_group1.id]
  subnet_id              = aws_subnet.private-subnet-1.id

  tags = {
    Name = "Web Server-2"
  }
}


# Description: Allow SSH, HTTP, HTTPS, 8080, 8081
resource "aws_security_group" "my_security_group1" {
  name        = "my-security-group1"
  description = "Allow SSH, HTTP, HTTPS, 8080 for Jenkins & Maven"
  vpc_id      = aws_vpc.my-vpc.id


  # SSH Inbound Rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH Outbound Rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
