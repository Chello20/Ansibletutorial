provider "aws" {
  region     = "us-east-1"             # Set your desired region
  access_key = ""  # Replace with your AWS access key
  secret_key = ""  # Replace with your AWS secret key
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create two subnets within the VPC
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"  # Modify if needed
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"  # Modify if needed
  map_public_ip_on_launch = true
}

# Create a security group within the VPC
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_vpc.main.id

  # Allow port 22 for SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow port 80 for HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create two EC2 instances with tags
resource "aws_instance" "ubuntu_instance_1" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro" # Adjust instance type as needed
  subnet_id     = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  key_name = "ansiblekey"

  tags = {
    Name = "Master"
  }
}

resource "aws_instance" "ubuntu_instance_2" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro" # Adjust instance type as needed
  subnet_id     = aws_subnet.subnet_b.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  key_name = "ansiblekey"

  tags = {
    Name = "Node"
  }
}

# Output the public IPs of the instances with the tags
output "master_public_ip" {
  value = aws_instance.ubuntu_instance_1.public_ip
  description = "Public IP of the Master instance"
}

output "node_public_ip" {
  value = aws_instance.ubuntu_instance_2.public_ip
  description = "Public IP of the Node instance"
}
