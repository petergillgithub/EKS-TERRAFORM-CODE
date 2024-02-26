terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.35.0"
    }
  }

  backend "s3" {

    bucket         = "demo-s3-bucket-peter"
    region         = "eu-west-2"
    dynamodb_table = "terraform-dynamodb-demo"

  }
}