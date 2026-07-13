# Project Title
Terraform code for infrastructure of Bird Watching app

## Description
This code configures a cloud infrastructure on AWS for Bird Watching application.

## Infrastructure components
- VPC with 1 public and 2 private subnets;
- S3 buckets (for terraform state, for images, for SSM connection and for security scans);
- security groups for each EC2 instance
- IAM role for each EC2 instance
- five EC2 instances (lb, web01, web02, db, jenkins, consul)
- route 53 (domain registration and DNS routing)

## Installation
To install Terraform on Linux you need to run these commands:
- `sudo apt-get update && sudo apt-get install -y gnupg software-properties-common`
- `wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
`
- `gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
`
- `echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list`
- `sudo apt update`
- `sudo apt-get install terraform`

To install Terraform on macOS:
Install 'Homebrew' if you don't have it, then run following commands:
- `brew tap hashicorp/tap`
- `brew install hashicorp/tap/terraform`

To install Terraform on Windows:
Install "Chocolatey" if you don`t have it, then run:
- `choco install terraform`

To verify successful installation run `terraform -help`. You should see the list of available commands.

## Usage
- Creating S3 bucket for terraform state
First cd to /state_bucket directory.
Change env, caller_identity and region to needed values.
Run `terraform init`.
Then run `terraform plan`. You will be given the list of changes that are going to be applied, make sure that the changes are exactly what you need.
Run `terraform apply`. S3 bucket for terraform state will be created and its name will be shown. Copy that name.
- Configuring the rest of infrastructure
cd to /iac.
In /tstate_to_s3 file change the value of "bucket" field to copied name.
Change environment, region and caller_id in /variables file to needed values.
Run `terraform init`.
Then run `terraform plan`. You will be given the list of changes that are going to be applied, make sure that the changes are exactly what you need.
Run `terraform apply`. All the resources specified higher will be created. Terraform state will be uploaded to specified S3 bucket.

## Built With
Terraform