terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.0"
    }
  }
}

provider "aws" {
  region = "sa-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id = true
  access_key = "mock"
  secret_key = "mock"
  s3_use_path_style = true

  endpoints {
    s3 = "http://localhost:4566"
    ec2 = "http://localhost:4566"
    # ALB not available on free tier localstack
    # elbv2 = "http://localhost:4566"
  }
}