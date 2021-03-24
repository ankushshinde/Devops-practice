# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = "<provide access key>"
  secret_key = "<provide secret key>"
}

# Create ec2 instance
resource "aws_instance" "my-first-instance" {
  ami           = "ami-013f17f36f8b"
  instance_type = "t2.micro"
  key_name = "instance-key"
  
  tags = {
    Name = "my-first-instance"
  }
