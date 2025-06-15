terraform {
  required_version = "1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.100.0"
    }
  }
  backend "s3" {
    profile                  = "default"
    shared_credentials_files = ["~/.aws/credentials"]
    bucket                   = "atrem-blob"
    region                   = "eu-central-1"
    key                      = "Terraform/terraform.tfstate"
    dynamodb_table           = "terdynamodb"
  }
}