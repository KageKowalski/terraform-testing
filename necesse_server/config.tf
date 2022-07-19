# Declare variables
variable "aws_access_key" {}
variable "aws_secret_key" {}


# Terraform configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
}


# AWS configuration
provider "aws" {
  region     = "us-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


# AMI for most recent Ubuntu Server 22.04.X OS
data "aws_ami" "ubuntu_server_ami" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# Necesse Server (ec2 instance)
resource "aws_instance" "necesse_ec2" {
  ami             = data.aws_ami.ubuntu_server_ami.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.necesse_sg.name]
  key_name        = aws_key_pair.ssh_key.key_name
}


# RSA key pair for SSH
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh.pub"
  public_key = file("ssh.pub")
}


# Public IP for Necesse Server (Elastic IP)
resource "aws_eip" "necesse_eip" {
  instance = aws_instance.necesse_ec2.id
  vpc      = true
}
output "necesse_eip_output" {
  value = aws_eip.necesse_eip.public_ip
}


# Security Group and Rules for Necesse Server
resource "aws_security_group" "necesse_sg" {
  name        = "necesse_sg"
  description = "Security Group for Necesse Server"
}
resource "aws_security_group_rule" "necesse_sg_http_out" {
  description       = "Allows http traffic out"
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.necesse_sg.id
}
resource "aws_security_group_rule" "necesse_sg_http_in" {
  description       = "Allows http traffic in"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.necesse_sg.id
}
resource "aws_security_group_rule" "necesse_sg_https_out" {
  description       = "Allows https traffic out"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.necesse_sg.id
}
resource "aws_security_group_rule" "necesse_sg_https_in" {
  description       = "Allows https traffic in"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.necesse_sg.id
}
resource "aws_security_group_rule" "necesse_sg_ssh_in" {
  description       = "Allows ssh traffic in"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.necesse_sg.id
}
resource "aws_security_group_rule" "necesse_sg_ssh_out" {
  description       = "Allows ssh traffic out"
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.necesse_sg.id
}
resource "aws_security_group_rule" "necesse_sg_server_in" {
  description       = "Allows Necesse server traffic in"
  type              = "ingress"
  from_port         = 14159
  to_port           = 14159
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.necesse_sg.id
}
resource "aws_security_group_rule" "necesse_sg_server_out" {
  description       = "Allows Necesse server traffic out"
  type              = "egress"
  from_port         = 14159
  to_port           = 14159
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.necesse_sg.id
}
