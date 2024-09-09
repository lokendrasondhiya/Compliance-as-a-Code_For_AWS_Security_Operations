#!/bin/bash

# Output file
OUTPUT_FILE="resource_ids.txt"

# Clear the output file if it exists
> $OUTPUT_FILE

# EC2 Instance IDs
echo "EC2: [" >> $OUTPUT_FILE
aws ec2 describe-instances --query "Reservations[].Instances[].InstanceId" --output text | sed 's/\s\+/", "/g; s/^/"/; s/$/"/' >> $OUTPUT_FILE
echo "]" >> $OUTPUT_FILE

# S3 Bucket Names
echo "S3: [" >> $OUTPUT_FILE
aws s3api list-buckets --query "Buckets[].Name" --output text | sed 's/\s\+/", "/g; s/^/"/; s/$/"/' >> $OUTPUT_FILE
echo "]" >> $OUTPUT_FILE

# IAM User Names
echo "IAM_USER: [" >> $OUTPUT_FILE
aws iam list-users --query "Users[].UserName" --output text | sed 's/\s\+/", "/g; s/^/"/; s/$/"/' >> $OUTPUT_FILE
echo "]" >> $OUTPUT_FILE

# IAM Role Names
echo "IAM_ROLE: [" >> $OUTPUT_FILE
aws iam list-roles --query "Roles[].RoleName" --output text | sed 's/\s\+/", "/g; s/^/"/; s/$/"/' >> $OUTPUT_FILE
echo "]" >> $OUTPUT_FILE

# EBS Volume IDs
echo "EBS: [" >> $OUTPUT_FILE
aws ec2 describe-volumes --query "Volumes[].VolumeId" --output text | sed 's/\s\+/", "/g; s/^/"/; s/$/"/' >> $OUTPUT_FILE
echo "]" >> $OUTPUT_FILE

echo "Resource IDs have been saved to $OUTPUT_FILE"

