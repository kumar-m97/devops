#List of all major terraform blocks to learn and revise

#Terraform + Provider
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

#variables
variable "env" {
  type    = string
  default = "dev"
}

variable "instance_count" {
  type    = number
  default = 1
}


#tfvars
env            = "prod"
instance_count = 2

#Locals
locals {
  name_prefix = "myapp-${var.env}"
  common_tags = {
    Project = "payments"
    Env     = var.env
    Owner   = "devops"
  }
}

#Outputs
output "bucket_name" {
  value = aws_s3_bucket.bucket.id
}

#Count
resource "aws_instance" "ec2" {
  count         = var.instance_count
  ami           = "ami-0abc"
  instance_type = "t2.micro"

  tags = {
    Name = "ec2-${count.index}"
  }
}


#for_each
variable "servers" {
  default = {
    web = "t2.micro"
    app = "t2.small"
  }
}

resource "aws_instance" "server" {
  for_each      = var.servers
  ami           = "ami-0abc"
  instance_type = each.value

  tags = {
    Name = each.key
  }
}

#Conditional Expression
variable "create_bucket" {
  type    = bool
  default = true
}

resource "aws_s3_bucket" "maybe" {
  count  = var.create_bucket ? 1 : 0
  bucket = "conditional-bucket"
}

#Dynamic Blocks
variable "ports" {
  default = [80, 443]
}

resource "aws_security_group" "sg" {
  name = "web-sg"

  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

#Lifecycle
resource "aws_s3_bucket" "safe" {
  bucket = "safe-bucket"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
    create_before_destroy = true
  }
}

#dependsOn
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  depends_on = [aws_vpc.main]
}


#DataSource
data "aws_ami" "latest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}


#Remote backend
terraform {
  backend "s3" {
    bucket         = "tf-states"
    key            = "prod/app/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }
}


#Workspaces
resource "aws_s3_bucket" "bucket" {
  bucket = "myapp-${terraform.workspace}"
}


#functions
locals {
  upper_env = upper(var.env)
  tags = merge(
    { Env = var.env },
    { App = "demo" }
  )
}


#provisioners
resource "aws_instance" "vm" {
  ami           = "ami-0abc"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y nginx"
    ]
  }
}


#Null resource
resource "null_resource" "build" {
  triggers = {
    version = var.app_version
  }

  provisioner "local-exec" {
    command = "echo Building version ${var.app_version}"
  }
}


#validation
variable "env" {
  type = string

  validation {
    condition     = contains(["dev","stage","prod"], var.env)
    error_message = "env must be dev, stage, or prod."
  }
}

#for Expression
variable "names" {
  default = ["app", "db", "cache"]
}

locals {
  upper_names = [for n in var.names : upper(n)]
}
