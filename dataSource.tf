terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.55.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

# Fetch the default/latest Amazon Linux AMI
data "aws_ami" "name" {
  most_recent = true
  owners      = ["amazon"]
}

output "aws_ami" {
  value = data.aws_ami.name.id
}

# Fetch the VPC details
data "aws_vpc" "name" {
  tags = {
    Name = "terraform_VPC"
  }
}

# Fetch the private subnet
data "aws_subnet" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.name.id]
  }
  tags = {
    Name = "private-subnet"
  }
}

# Fetch the public subnet (Ensure this subnet exists in your AWS account)
data "aws_subnet" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.name.id]
  }
  tags = {
    Name = "public-subnet"
  }
}

# Launch EC2 instance in the public subnet
resource "aws_instance" "VPC-ec2" {
  ami           = "ami-0b02608ac063c1939"
  instance_type = "t3.nano"
  subnet_id     = data.aws_subnet.public.id  # Corrected reference

  tags = {
    Name = "VPC-ec2"
  }
}
