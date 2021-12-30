# o8t AWS Demo

The entire infrastructure is built under Sydney region (ap-southeast-2).

## Prerequisites

- Terraform >= 1.0.1
- An AWS account with sufficient permission to provision all necessary resources, such as VPC, ELB, Autoscaling Group, and so on.
- Awscli >= 2.2.14

## Configuration

- All varables are defined in variables.tf
- Either pre-assign values to variables in vars.tf, or assign them on the fly when running the script
- Ensure AWS access key and secret are exported as environment variable properly

```bash

export AWS_ACCESS_KEY_ID=xxxx
export AWS_SECRET_ACCESS_KEY=xxxxx
export AWS_DEFAULT_REGION=ap-southeast-2

```

## Usage

Initialize the working directory containing Terraform configuration files

```bash
make init
```

Do a dry run to check the resources will be provisioned/changed.

```bash
make plan

```

- You need to supply AWS access key, AWS secret key, region, and account ID.
- Feel free to replace any variables' value defined in variables.tf file.

#### Deploy the resources

```bash

make build KEY=changeme SECRET=changeme

```

#### Destroy the resources

```bash
make clean KEY=changeme SECRET=changeme

```

## State file

'terraform.tfstate' holds the state of the deployed resources, which would be stored in the **xxx-tf-state** S3 bucket.

Note: The bucket is required to be created before running the code.

## Private Key

Newly generated private key are uploaded to **xxx-tf-state** S3 bucket.

## Access the web server

You should be able to access the web server by hitting the output value **elb_url**.


## How to check web server status

```bash
make check
```
The script would start to output 'webserver is UP' .
To demonstrate the server down scenario, manually change the autoscaling group's desired capacity and miminal capacity to '0'; the script would start to output 'webserver is DOWN'.

## How to demonstrate a scaling event (extra mile)

By hitting on <elb_url>
for more than 20 times within 1 minute, and wait for about 5-10 minutes, an alarm event will trigger a scaling up event for the autoscaling group.

After a few minutes, hit the <elb_url> only once, and wait for about 5-10 minutes, the autoscaling group will be scaled down by another alarm event.