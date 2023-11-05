provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "tls_private_key" "temp_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "temp_key"
  public_key = "${tls_private_key.temp_key.public_key_openssh}"
}

data "template_file" "init" {
  count = "${var.instance_count}"
  template = "${file("action_run.tpl")}"
  vars = {
    count = "${count.index}"
    total = "${var.instance_count}"
    s3_bucket = "${random_id.s3.hex}"
    scan_list = "${var.scan_list}"
  }
}
resource "aws_iam_role" "temp_role" {
  name = "temp_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_instance_profile" "temp_profile" {
  name = "temp_profile"
  role = "${aws_iam_role.temp_role.name}"
}
resource "aws_iam_role_policy" "temp_policy" {
  name = "temp_policy"
  role = "${aws_iam_role.temp_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
resource "aws_instance" "vm-ubuntu" {
  
  lifecycle {
    ignore_changes = [
      instance_type,
    ]
  }
  iam_instance_profile = "${aws_iam_instance_profile.temp_profile.name}"
  count         = "${var.instance_count}"
  user_data = "${element(data.template_file.init.*.rendered, count.index)}"
  ami                         = "ami-04b9e92b5572fa0d1"
  instance_type               = "t2.micro"
  key_name                    = "temp_key"
  associate_public_ip_address = true
  source_dest_check           = false
  vpc_security_group_ids      = [aws_security_group.sg-ubuntu.id]
  depends_on = [
  aws_key_pair.generated_key
  ]
}

resource "random_id" "s3" {
  byte_length = 8
}

resource "aws_s3_bucket" "scanning_storage" {
  bucket        = random_id.s3.hex
  force_destroy = true
}



resource "aws_s3_bucket_ownership_controls" "scanning_storage_ownership" {
  bucket = aws_s3_bucket.scanning_storage.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.scanning_storage.id
  key    = var.scan_list
  source = var.scan_list
  depends_on = [
    aws_s3_bucket.scanning_storage,
    aws_s3_bucket_ownership_controls.scanning_storage_ownership
  ]
}

# UBUNTU SECURITY GROUP
resource "aws_security_group" "sg-ubuntu" {
  name        = "sg_${var.host_name}"
  description = "sg-${var.host_name}"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.allow_ingress]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

