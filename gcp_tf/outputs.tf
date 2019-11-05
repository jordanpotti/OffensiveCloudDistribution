output "instance_public_ip_addresses" {
  value = {
    for instance in google_compute_instance.vm_instance:
    instance.id => instance.network_interface.0.access_config.0.nat_ip
  }
}

output "instance_private_ip_addresses" {
  value = {
    for instance in google_compute_instance.vm_instance:
    instance.id => instance.network_interface.0.network_ip
  }
}

output "bucket_name" {
  value = google_storage_bucket.action_storage.name
}

output "project_id" {
  value = google_compute_instance.vm_instance.0.project
}

output "project_zone" {
  value = google_compute_instance.vm_instance.0.zone
}

output "ssh_command" {
  value =  "gcloud beta compute ssh --project [project-id] --zone [gcp-zone] [instance-id]"
}
