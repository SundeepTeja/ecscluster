terraform {
  required_providers {
    aws = {
      version = ">= 3.63.0"
      source  = "hashicorp/aws"
    }
  }
}

variable "region" {}
variable "project" {}
variable "environ" {}