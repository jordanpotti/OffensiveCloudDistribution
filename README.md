# OffensiveCloudDistribution
Have you ever needed to scan 3 million hosts with masscan? What about running EyeWitness on 5k servers.. Without sacrificing accuracy, those things will take quite awhile! 
What if you could stand up 50 EC2 instances to each take a small part of the work, have each of the instances spit the results to an S3 Bucket, and then spin down the instances. All while staying in the Free AWS Tier. This Terraform module lets you do that! 

## What do I need to get started?
An AWS account

Yes, thats it! The scripts contained here set up Terraform for you, configure the EC2 instances and setup the S3 bucket for you.

## Other Platforms
Currently, the Terraform module here is based on AWS. GCP's free Tier is much more generous so if you want to learn Terraform, use the AWS module here as template to create a GCP Terraform module, PR's are welcome :) 

## Disclaimer:
Please be aware of the AWS Free Tier rules. Using instances that qualify for the free tier, you can utilize 750 hours per month. My modifying certain pieces of the Terraform module (Like changing the instances size), and not destroying the AWS resources after your job is done, you will likely incur hefty AWS charges.
https://aws.amazon.com/free/terms/

