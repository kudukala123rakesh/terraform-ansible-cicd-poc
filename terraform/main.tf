provider "aws" {
  region = "us-east-1"
}

# Generate SSH key
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair
resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Create EC2 instance
resource "aws_instance" "demo_ec2" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.terraform_key.key_name

  tags = {
    Name = "terraform-ansible-cicd"
  }
}
