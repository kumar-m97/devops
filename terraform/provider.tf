provider "aws" {
    region = "us-east-1"
    alias = "provider1"
}


// Another way to define the providers
/*terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}*/