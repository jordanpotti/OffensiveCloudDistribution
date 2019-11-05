## Getting Started

Ensure your creds are downloaded from the Cloud Console and env vars are set
`export GOOGLE_CLOUD_KEYFILE_JSON={{path}}`
or, if you're using a service account
`export GOOGLE_APPLICATION_CREDENTIALS={{path}}`

Make any modifications to the `variables.tf` and `action_run.tpl` files. No changes are required, but note the region and zone are defaulted to `us-central1-a`, there are no restrictions on which IPs can access port 22 on the created, and instances are created without oauth scope restrictions.

Run `terraform apply`.

To destroy, run `terraform destroy`

Terraform Reference: https://www.terraform.io/docs/providers/google/provider_reference.html

### Accessing your instances
Assuming you have the Google [CloudTools SDK for CLI](https://cloud.google.com/sdk/docs/#deb)..

The SSH keys are per instance and created automatically. There are other SSH access options with GCP such as OS Login - feel free to submit a PR. 
`gcloud beta compute --project "your-project-name" ssh --zone "us-central1-a" "your-instance-id"`
`gcloud compute ssh --project [PROJECT_ID] --zone [ZONE] [INSTANCE_NAME]`

Reference: 
* https://cloud.google.com/compute/docs/instances/connecting-to-instance
* https://cloud.google.com/compute/docs/instances/managing-instance-access

### Viewing output
You can watch the serial port console output in the Cloud Console or use the below command. The default masscan can take a few minutes to update and compile and then timing will be dependent on whatever your action is.
```
gcloud compute instances get-serial-port-output instance-name \
  --port port \
  --start start \
  --zone zone
```
Having issues? Try here - https://cloud.google.com/compute/docs/troubleshooting/

### Storage 
Interact with Google Cloud Storage 
`gsutil ls`

Note that 50GB of storage may cost you a dollar.

### Pricing
https://cloud.google.com/free/docs/gcp-free-tier#always-free-usage-limits
