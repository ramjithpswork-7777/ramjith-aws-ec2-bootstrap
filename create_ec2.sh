#!/bin/bash
# create_ec2.sh - Launches EC2 instance with user-data script

set -e
KEY_NAME=${1:-my-key}
SG_ID=${2:-sg-xxxxxxxx}
AMI_ID="ami-0bb7d855677353076"  # example for ap-south-1
INSTANCE_TYPE="t2.micro"
USER_DATA_FILE="bootstrap.sh"

INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --count 1 \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-group-ids $SG_ID \
  --user-data file://$USER_DATA_FILE \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=ramjith-demo}]' \
  --query 'Instances[0].InstanceId' --output text)

echo "Launched instance: $INSTANCE_ID"
aws ec2 wait instance-running --instance-ids $INSTANCE_ID
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
echo "Instance ready at http://$PUBLIC_IP"
