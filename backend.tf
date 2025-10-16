terraform {
  backend "s3" {
    bucket         = "youssefterraformbucket" #My bucket
    key            = "terraform.tfstate"      #Key name
    region         = "us-east-1"              #Region
    use_lockfile  = true              #Encrypt
  }
}
