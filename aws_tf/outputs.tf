output "instance_public_ip_addresses" {
  value = {
    for instance in aws_instance.vm-ubuntu:
    instance.id => instance.public_ip
  }
}
output "instance_private_ip_addresses" {
  value = {
    for instance in aws_instance.vm-ubuntu:
    instance.id => instance.private_ip
  }
}
output "Private_SSH_Key_Value" {
  value = "${tls_private_key.temp_key.private_key_pem}"
  sensitive = true
}

output "s3_bucket" {
  value = "${random_id.s3.hex}"
}

output "Username" {
  value = "ubuntu"
}
