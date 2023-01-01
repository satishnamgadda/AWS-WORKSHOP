# ubuntu 22.04 ami-id in any region
aws ec2 describe-images --filters "Name=owner-id,Values=099720109477" "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20221201" --query "Images[].ImageId" --output text
# RHEL 9 ami-id in any region
aws ec2 describe-images --filters "Name=owner-id,Values=309956199498" "Name=name,Values=RHEL-9.1.0_HVM-20221101-x86_64-2-Hourly2-GP2" --query "Images[].ImageId" --output text
# query the all vpcs in any region
aws ec2 describe-vpcs --query "Vpcs[].VpcId" --region <region-name>
# query the default vpc in any region
aws ec2 describe-vpcs --query "Vpcs[?IsDefault].VpcId" --region <region-name>