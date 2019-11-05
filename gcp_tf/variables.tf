variable "gcp_region" {
  description = "Region for the VPC (e.g. us-central1)"
}

variable "gcp_zone" {
  description = "Zone for the VPC (e.g. us-central1-a)"
}

variable "project_id" {
  description = "Your GCP Project Name"
}

variable "host_name" {
  description = "Host name to give server"
}

variable "allow_ingress" {
  description = "CIDR/IP that will be allowed to access the host (0.0.0.0/0)"
  default = "0.0.0.0/0"
}

variable "scan_list" {
  description = "File with list of IP's to scan"
}

variable "instance_count" {
}
