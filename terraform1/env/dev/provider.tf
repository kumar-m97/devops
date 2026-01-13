terraform{
    required_providers {
        aws = {
            source =
            version =
        }
    }
}

provider "aws" {
    region = "us-east-1"
    profile = "default"
    alias   = "dev"
}