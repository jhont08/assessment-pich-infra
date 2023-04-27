terraform {
  backend "s3" {
    bucket  = "jftriana-terraform-states"
    key     = "pichincha/terraform.tfstate"
    region  = "us-east-1"
    profile = "personal"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = "~> 1.1.9"
}
