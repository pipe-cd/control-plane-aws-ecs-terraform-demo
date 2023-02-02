terraform {
  backend "s3" {
    bucket  = "example-pipecd-control-plane-tfstate" #your bucket name for terraform backend
    region  = "ap-northeast-1"
    key     = "tfstate"
    profile = "pipecd-control-plane-terraform" #your profile
  }
  required_providers {
    aws = {
      version = "~> 3.34.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "pipecd-control-plane-terraform" #your profile
}