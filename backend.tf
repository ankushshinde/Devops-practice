terraform {
  backend "s3" {
    bucket = "my-terraform-status"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
