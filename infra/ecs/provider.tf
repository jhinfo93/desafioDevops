terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-local-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "${terraform.workspace}"
      Owner       = "Jackin"
      Project     = "Teste Devops"
    }
  }
}