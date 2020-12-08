variable "aws_region" {
  description = "Region for the VPC"
  default     = "us-west-2"
}

variable "inks" {
  description = "Inks Inc"
  default     = "inks"
}

variable "interview" {
  description = "Environment for interview"
  default     = "int"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.0.0.0/16"
}

variable "private_subnet_1_cidr" {
  description = "Private subnet 1"
  default     = "10.0.0.0/24"
}

variable "private_subnet_2_cidr" {
  description = "Private subnet 2"
  default     = "10.0.1.0/24"
}

variable "public_subnet_1_cidr" {
  description = "Public subnet 1"
  default     = "10.0.128.0/24"
}

variable "public_subnet_2_cidr" {
  description = "Public subnet 2"
  default     = "10.0.129.0/24"
}

variable "ami_id" {
  description = "Ubuntu 18.04 AMI"
  default     = "ami-0b24de764f65580a5"
}

variable "pub_key_path" {
  description = "SSH Public Key path"
  default     = "~/.ssh/id_rsa.pub"
}

variable "userdata" {
  description = "User Data"
  default     = "#!/usr/bin/env bash\n        apt-get update -y && apt-get install apache2 -y \n              echo \"Job interviews are fun!\" > /var/www/html/index.html\n"
}

variable "app_instance_type" {
  description = "EC2 instance type for app host"
  default     = "t2.micro"
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(map(string))
  default     = []
}
