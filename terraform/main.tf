# ec2 instance
resource "aws_instance" "instance1" {
    ami                 = " "  #paste the ami id from aws console
    region              = "us-east-1"
    intance_type        = "t2.micro"
    key_name            = " " #give key-pair using variable which is defined in variable.tf file
    associate_public_ip_address = true
    provider            = aws.provider1
    tag {
        name = "1st instance"
    }
}

# s3 bucket
resource "aws_s3_bucket" "bucket1" {
    bucket = "my_bucket1_2025" # must be unique
}

# key pair
resource "aws_key_pair" "key_pair1" {
    key_name                = "key-pair-1"
    public_key              = file("~/.ssh/id_rsa.pub)  #define a variable in variable.tf file
}

#cretaing aws instances using for_each loops
resource "aws_instance" "env_servers" {
  for_each = var.environments

  ami           = "ami-0c55b159cbfafe1f0" # Replace with a valid AMI for your region
  instance_type = "t2.micro"

  tags = {
    Name        = each.value
    Environment = each.key
  }
}