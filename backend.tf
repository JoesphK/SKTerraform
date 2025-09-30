terraform {
  backend "s3" {
    bucket = "youssefterraformbucket"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}