locals {
  env = "PRDUCTION" # It could be PROD, STAGING, DEV, etc
}

provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region                  = "us-east-1"          # us-east-1
  profile                 = "default"
}

module "StoreOne-VPC-PRODUCTION" {
  source = "./modules"
}
