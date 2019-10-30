# OffensiveCloudDistribution
Have you ever needed to scan 3 million hosts with masscan? What about running EyeWitness on 5k servers.. Without sacrificing accuracy, those things will take quite awhile! 
What if you could stand up 50 EC2 instances to each take a small part of the work, have each of the instances spit the results to an S3 Bucket, and then spin down the instances. All while staying in the Free AWS Tier. This Terraform module lets you do that! 

## What do I need to get started?
- An AWS account
- Terraform

Yes, thats it! The scripts contained here configure the EC2 instances, kick the actions off and throw the results into an S3 bucket for you.

### Getting Started
1. Download and install Terraform for your platform. https://www.vasos-koupparis.com/terraform-getting-started-install/
2. Create an AWS account if you don't already have one.
3. Retrieve the AWS access and secret keys
4. `git clone https://github.com/jordanpotti/OffensiveCloudDistribution`
5. `cd OffensiveCloudDistribution/aws_tf`
6. `terraform init`
7. `terraform apply` ; You will need to enter a couple values here such as how many instances, the host name, the IP you want to SSH into the instances with and a line delimeted list of IP's to scan.
8. The results will give you the IP, as well as the Private SSH key. Copy this key into a `.pem` file to SSH into the servers.
9. The results of the scan (Or custom action specified by you) will end up in a randomly named S3 Bucket. Download the files placed ther from the scan before you run `terraform destroy` since this will destroy your S3 bucket as well.

### Troubleshooting
To verify a scan kicked off, or troubleshoot an action, SSH into one of your servers and run `tail -f /var/log/cloud-init-output.log`, that will also let you track the progress of your scans.



## Other Platforms
Currently, the Terraform module here is based on AWS. GCP's free Tier is much more generous so if you want to learn Terraform, use the AWS module here as template to create a GCP Terraform module, PR's are welcome :) 

## Disclaimer:
Please be aware of the AWS Free Tier rules. Using instances that qualify for the free tier, you can utilize 750 hours per month. By modifying certain pieces of the Terraform module (Like changing the instance size), and not destroying the AWS resources after your job is done, you will likely incur hefty AWS charges.
https://aws.amazon.com/free/terms/

