# CREATE AN EC2 INSTANCE USING AWSCLI
# TO CREATE EC2 INSTANCE , WE NEED THE FOLLOWING

For creating ec2 instance we have following needs
AMI id: They differ from region to region for the same OS (ubuntu 22.04)
Network
VPC (Region): AWS CLI by default uses default vpc to launch ec2 instance.
Subnet id: For choosing specific AZ.
Security Group: Solved as part of activity 8
Key-Pair:
Use the current machines id_rsa.pub (i.e. import)
Create a new key pair and store it some where in your system.
Size:
EC2: this can be a parameter
EBS: this can be a parameter

# ' aws ec2 describe-images --image-ids ami-03d3eec31be6ef6f9 > images.json
![preview](/Images/awscli1.png)    
$ aws ec2 describe-images --image-ids ami-03d3eec31be6ef6f9
{
    "Images": [
        {
            "Architecture": "x86_64",
            "CreationDate": "2022-12-01T22:14:47.000Z",
            "ImageId": "ami-03d3eec31be6ef6f9",
            "ImageLocation": "amazon/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20221201",
            "ImageType": "machine",
            "Public": true,
            "OwnerId": "099720109477",
            "PlatformDetails": "Linux/UNIX",
            "UsageOperation": "RunInstances",
            "State": "available",
            "BlockDeviceMappings": []}]}  
# aws ec2 describe-images --filters "Name=owner-id,Values=099720109477" "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20221201" --query "Images[].ImageId" 

$ aws ec2 describe-images --filters "Name=owner-id,Values=099720109477" "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20221201" --query "Images[].ImageId"
[
    "ami-03d3eec31be6ef6f9"
]
# to remove the quotes in o/p
$ aws ec2 describe-images --filters "Name=owner-id,Values=099720109477" "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20221201" --query "Images[].ImageId" --output text
ami-03d3eec31be6ef6f9

# to get ubuntu20.04 ami-id in any region use '--region <region-name>'
$ aws ec2 describe-images --filters "Name=owner-id,Values=099720109477" "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20221201" --query "Images[].ImageId" --region us-west-2 --output text
ami-0530ca8899fac469f
# Exercise: Try to find AMI id of Redhat Linux 9 which works for all regions
# Hint: use Name and owner id for fetching images uniquely
$ aws ec2 describe-images --filters "Name=owner-id,Values=309956199498"  "Name=name,Values=RHEL-9.1.0_HVM-20221101-x86_64-2-Hourly2-GP2" --query "Images[].ImageId" --output text
ami-0f9d9a251c1a44858

# to get the RED HAT LINUX 9 ami-id in any region use '--region <region-name>'
$ aws ec2 describe-images --filters "Name=owner-id,Values=309956199498"  "Name=name,Values=RHEL-9.1.0_HVM-20221101-x86_64-2-Hourly2-GP2" --query "Images[].ImageId" -- region us-west-1 --output text 
ami-01545383151c0674e
# To get the default vpc
$ aws ec2 describe-vpcs --query "Vpcs[?IsDefault].VpcId" --output text
vpc-06d9bc98a2b3a2108

# To get the default vpc in any region use `--region <region-name>`
$ aws ec2 describe-vpcs --query "Vpcs[?IsDefault].VpcId" --region us-west-2 --output text
vpc-09c15b52ef67ed9d8

# To get the subnet in default vpc with availability-zone `ap-south-1b`
$ aws ec2 describe-subnets --filters "Name=availability-zone,Values=ap-south-1b" "Name=vpc-id,Values=vpc-06d9bc98a2b3a2108" --query "Subnets[].SubnetId" --output text
subnet-092eb948953e49a55

# To get the Security Group in default vpc with name
$ aws ec2 describe-security-groups --filters "Name=vpc-id,Values=vpc-06d9bc98a2b3a2108" --group-names "launch-wizard-1" --query "SecurityGroups[].GroupId" --output text
sg-07badd16ad39e26fb
# to get the count of keypairs with name
$ aws ec2 describe-key-pairs --filters "Name=key-name,Values=my-id-rsa" --query "KeyPairs[] | length(@)" --region $region
1

# to create the imported key-pair with name
$ aws ec2 import-key-pair --key-name "my-id-rsa" --public-key-material  fileb://~/.ssh/id_rsa.pub

# Lets create an ec2 instance in the specified region , in specified vpc/subnet with security group and key pair with instance size, disk size as parameter
aws
