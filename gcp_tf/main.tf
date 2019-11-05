provider "google" {
  project     = "${var.project_id}"
  region      = "${var.gcp_region}"
  zone	      = "${var.gcp_zone}"
}

# Set up the Google Compute Instance
resource "random_id" "instance_name" {
  byte_length = 8
}
resource "google_compute_instance" "vm_instance" {
  name         	= "${var.host_name}-${random_id.instance_name.hex}-${count.index}"
  count         = "${var.instance_count}"
  machine_type 	= "f1-micro"
  service_account {
    scopes = ["cloud-platform"]
  }
  metadata_startup_script = "${element(data.template_file.init.*.rendered, count.index)}"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "${google_compute_network.vpc_network.self_link}"
    access_config {
    }
  }
  lifecycle {
    ignore_changes = [
      machine_type,
    ]
  }
}
resource "google_compute_network" "vpc_network" {
  name = "temp-terraform-network"
  auto_create_subnetworks = "true"
}
resource "google_compute_firewall" "default" {
  name    = "temp-terraform-firewall"
  network = "${google_compute_network.vpc_network.self_link}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [var.allow_ingress]
}


# Setup the storage config, private by default
resource "random_id" "bucket_name" {
  byte_length = 8
}
resource "google_storage_bucket" "action_storage" {
  name		= "${random_id.bucket_name.hex}"
  force_destroy = true
}
resource "google_storage_bucket_object" "object" {
  bucket	= "${random_id.bucket_name.hex}"
  name   	= "${var.scan_list}"
  source 	= "${var.scan_list}"
  depends_on 	= [google_storage_bucket.action_storage]
}


# Configure scaling distribution, vars used in tpl
data "template_file" "init" {
  count = "${var.instance_count}"
  template = "${file("action_run.tpl")}"
  vars = {
    count = "${count.index + 1}"
    total = "${var.instance_count}"
    bucket = "${random_id.bucket_name.hex}"
    scan_list = "${var.scan_list}"
  }
}
