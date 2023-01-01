#!/bin/bash
region=$1
owner_id=309956199498
image_name=RHEL-9.1.0_HVM-20221101-x86_64-2-Hourly2-GP2
default_region=ap-south-1
sg_name=launch-wizard-1
publickey_filename=id_rsa.pub
key_name=my-id-rsa1
instance_type=t2.micro
instance_count=1
if [[ -z "$region" ]]; then
  echo "region is not passed so ${default_region} will be  considered"
  region=$default_region
fi
az=${region}b

ami_id=$(aws ec2 describe-images --filters "Name=owner-id,Values=${owner_id}"  "Name=name,Values=${image_name}" --query "Images[].ImageId" --region $region --output text)
echo "found RED HAT ami: ${ami_id} in region $region"

vpc_id=$(aws ec2 describe-vpcs --query "Vpcs[?IsDefault].VpcId" --region $region --output text)
echo " found default vpc-id: ${vpc_id} in region $region"

subnet=$(aws ec2 describe-subnets --filters "Name=availability-zone,Values=$az" "Name=vpc-id,Values=${vpc_id}" --region $region --query "Subnets[].SubnetId" --output text)
echo " subnet Found in availability-zone: $az with id: ${subnet}"

sg_id=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=${vpc_id}" --group-names "${sg_name}" --region $region --query "SecurityGroups[].GroupId" --output text)
echo " Found security Group in vpc: ${vpc_id} with id: ${sg_id}"

count=$(aws ec2 describe-key-pairs --filters "Name=key-name,Values=$key_name" --query "KeyPairs[] | length(@)" --region $region)
if [[ $count -eq 0 ]]; then
 echo " key pair ${key_name} does n't exists so creating"
aws ec2 import-key-pair --key-name "$key_name" --public-key-material  "fileb://~/.ssh/${publickey_filename}"
fi
echo "key pair ${key_name} exists"

count1=$(aws ec2 describe-instances --filters "Name=tag-value,Values=vm4" --query "Reservations[].Instances[].InstanceId | length(@)" --region $region)
if [[ $count1 -eq 0 ]]; then
echo "tag does n't exists so creating"
instance_id=$(aws ec2 run-instances --image-id ${ami_id} \
        --instance-type ${instance_type} \
        --key-name ${key_name} \
        --security-group-ids ${sg_id} \
        --subnet-id ${subnet} \
        --associate-public-ip-address \
        --region $region \
        --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=vm4}]' \
        --query "Instances[0].InstanceId" \
        --output text)
 echo " created ec2 instance with instance-id ${instance_id}"
fi
echo "created ec2 instance with instance-id: ${instance_id}"