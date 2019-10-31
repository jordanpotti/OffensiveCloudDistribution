variable "aws_region" {
  description = "Region for the VPC"
  default     = "us-east-1"
}

variable "host_name" {
  description = "Host name to give server"
}

variable "secret_key" {}
variable "access_key" {}


variable "allow_ingress" {
  description = "IP that will be allowed to access the Ubuntu host ie, x.x.x.x/x"
}

variable "instance_count" {
}


variable "scan_list" {
  description = "List of IP's to scan (Enter file name here)"
}
