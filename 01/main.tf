terraform{
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.0"  
        }
    }
}

provider "aws" {
    region = "eu-west-1"
}

resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

    tags = {
        Name = "Terraform Demo VPC"
    }
}

resource "aws_subnet" "app_subnet" {
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "db_subnet" {
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "demo_igw" {
    vpc_id = aws_vpc.demo_vpc.id
}

resource "aws_route_table" "demo_routes" {
    vpc_id = aws_vpc.demo_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.demo_igw.id
    }
}

resource "aws_route_table_association" "demo_rs_asso" {
    route_table_id = aws_route_table.demo_routes
    subnet_id = aws_subnet.app_subnet
}