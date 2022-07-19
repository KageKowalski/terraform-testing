# Terraform Testing

## Introduction

This repository was created in order to test simple Terraform deployments to my
personal AWS account. When I am finished experimenting with a Terraform
deployment, I will archive all the relevant code in a folder in this repo and
create a section in this README explaining the purpose of the code. Archiving the code will
allow me and anyone else interested in perusing my examples to benefit from them
in the future.

Any code outside of a folder (in the root of the repository) is code that I am
currently testing.

## clean_s3

The purpose of clean_s3 is to create a Lambda function, an s3 bucket, and all
relevant roles / policies / etc in order for the lambda to accomplish what it is
intended to accomplish. The lambda function, clean_s3.py, deletes all files
in the passed s3 buckets, excluding whitelisted files, directories, and files
that are newer than a given threshold date. See below for specifics regarding
individual directories and files.

**lambdas**\
Folder containing 1 lambda function, clean_s3.py. This folder exists to
separate the lambda from the Terraform code.

**clean_s3.py**\
clean_s3.py is a lambda function written in Python that deletes files
from the passed s3 bucket(s). Specifically, it ignores whitelisted
files, all directories, and files newer than a given cutoff date. The
whitelisted files, bucket name(s), and cutoff date are passed to the function
through its event.

**config.tf**\
Holds declared variables (but not full variable definitions), the Terraform
configuration information, and the provider (AWS) configuration information.

**lambda.tf**\
Includes all information necessary to create a lambda function in AWS out
of clean_s3.py, including a zip (the file must be zipped in order to
obtain its hash, which is necessary to create the lambda function), the
lambda function (created from the hash of the zip), the relevant role,
policy, and policy attachments, and a basic assume role policy, which allows
the lambda to assume its role.

**s3.tf**\
Includes all information necessary to create the s3 bucket which clean_s3 is
intended to act upon. Specifically, this includes the s3 bucket, the s3
bucket's policy, and a folder in the bucket. The folder was created for
testing purposes and is not necessary.

**terraform.tfvars**\
Holds definitions of variables declared in config.tf.

## necesse_server

The purpose of necesse_server is to create the necessary AWS infrastructure
for a fully functioning Necesse multiplayer server. The code 
could theoretically be copied and altered to set up a similar multiplayer
video game server for a different video game.

**Steps to run server**
1. Build Terraform
2. Run necesse_ec2_init.sh script on ec2 instance as ubuntu user from home
3. Launch the server once manually and configure desired settings
   1. To launch server, run StartServer-nogui.sh at below directory:
   2. ~/Steam/steamapps/common/Necesse\ Dedicated\ Server
4. Save, daemon-reload, enable, and start "necesse.service" on ec2 instance

**config.tf**\
Contains all terraform code for provisioning the AWS infrastructure
necessary for the server to run. The most important unique pieces
here are necesse_ec2, which is the ec2 instance that acts as the server,
and necesse_sg + necesse_sg_*, which is the security group defining the
firewall rules for the ec2 instance, as well as all of the individual
firewall rules making up the security group. An output block is defined
to print the public IP address of the server when Terraform builds.

**necesse_ec2_init.sh**\
This is the initialization script for software that needs to run on the
ec2 instance. This script should be copied to the ec2 instance and executed
from the home directory of the ubuntu user. The script will install all
necessary software for the server to run. The script is accurate as of
July 18th 2022 and would need to be updated if running a server for a
different game, or if running a Necesse server in the future after the
installation procedure changes.

**ssh.pub**\
The public ssh key to remote into the ec2 instance, in order to configure
the server. This file currently contains my personal public ssh key and
must be updated to reflect the ssh key of the user configuring the server.

**necesse.service**\
The service (unit) file to run the Necesse server automatically on the
ec2 instance.
