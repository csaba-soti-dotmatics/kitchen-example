resource "aws_instance" "test-csaba-atlantis" {
//  id = "i-0cd18e9d282138012"
//  arn = "arn:aws:ec2:eu-west-1:101999902141:instance/i-0cd18e9d282138012"

  ami               = "ami-0ce71448843cb18a1"
  associate_public_ip_address = true
  availability_zone = "eu-west-1a"
  instance_type     = "t2.micro"
  key_name          = "csaba_d40_test"
  vpc_security_group_ids = ["${aws_security_group.test-csaba-sg.id}"]
  subnet_id         = "subnet-02a9527057089c144"
  tags {
    Name = "test-csaba-atlantis"
  }
  user_data = <<EOF
#! /bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker
sudo service docker start
sudo usermod -a -G docker ec2-user
EOF

}

resource "aws_security_group" "test-csaba-sg" {
  name        = "test-csaba-sg"
  description = "Allow atlantis ec2 from GitHub & Csabas MacBook only"
  vpc_id      = "vpc-05c9f5547468f7fe7"


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["192.30.252.0/22","185.199.108.0/22","140.82.112.0/20","31.10.34.106/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["31.10.34.106/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
