terraform {
  required_version = ">= 1.9"

  backend "s3" {
    # Configure via: terraform init -backend-config="bucket=<state-bucket>" \
    #                              -backend-config="key=my-agent/terraform.tfstate"
    dynamodb_table = "my-agent-tf-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
