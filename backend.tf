terraform {
  backend "s3" {
    bucket = "youssefterraformbucket" #My bucket
    key    = "terraform.tfstate"      #Key name
    region = "us-east-1"              #Region
    #dynamodb_table = "terraform-locks" #Enable the lock
    #encrypt = true #Encrypt
  }
}