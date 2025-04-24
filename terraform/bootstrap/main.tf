provider "aws" {
  region = var.aws_region

}

 terraform {
  backend "s3" {}
 }


 
module "bootstrap" {
  source = "../modules/bootstrap"
  bucket_name         = var.bucket_name
  dynamodb_table_name = var.dynamodb_table_name
}
