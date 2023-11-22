terraform {
  required_providers {
    aws = {
      version = ">= 3.63.0"
      source  = "hashicorp/aws"
    }
  }
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