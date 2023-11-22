terraform {
  required_providers {
    aws = {
      version = ">= 3.63.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "xxxxxxxxxxxxxxxxxx"
  secret_key = "xxxxxxxxxxxxxxxxxx"
}

variable "region" {
  default = "us-east-1"
}
variable "project" {
  default = "ecscluster"
}
variable "environ" {
  default = "dev"
}