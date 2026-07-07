# Base packer image

## Requirements
* Packer 1.15.4
* AWS-cli 2.31.35
* Python/3.14.4
* boto3 1.40.72
* botocore 1.40.72


## Installing / Getting started

* [Packer](https://developer.hashicorp.com/packer/install) should be installed
* Inside the folder do `packer init` in bash
* `packer fmt ./{FILE_NAME.pkr.hcl}` and `packer validate ./{FILE_NAME.pkr.hcl}`
* `packer build ./{FILE_NAME.pkr.hcl}` inside of bash in order to start building the AMI in AWS

## Features

* Creates an AMI with 4 public keys and regular Trivy Security scans and Consul
