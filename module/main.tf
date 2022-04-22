provider "aws" {
    region = "eu-central-1"
}
 resource "aws_s3_bucket" "terraform_state" {
    bucket = "study-bucket-1-homework"
    versioning {
        enabled = true
    }

 }
 locals {
  count_vm = {
    stage = 1
    prod = 2
  }
 }

 module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  count = local.count_vm[terraform.workspace]
  name = "HW-${count.index+1}"
 }
