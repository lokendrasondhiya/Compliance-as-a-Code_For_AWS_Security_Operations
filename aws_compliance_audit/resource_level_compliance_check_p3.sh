#!/bin/bash

# File containing resource IDs
RESOURCE_FILE="resource_ids.txt"

# Check if the file exists
if [ ! -f "$RESOURCE_FILE" ]; then
  echo "Resource file not found!"
  exit 1
fi

# Function to check compliance for a given resource type
check_compliance() {
  local resource_type=$1
  local resource_id=$2

  echo "Checking compliance for $resource_type with ID: $resource_id"

  case "$resource_type" in
    EC2)
      aws configservice get-compliance-details-by-resource --resource-type AWS::EC2::Instance --resource-id "$resource_id"
      ;;
    S3)
      aws configservice get-compliance-details-by-resource --resource-type AWS::S3::Bucket --resource-id "$resource_id"
      ;;
    IAM_USER)
      aws configservice get-compliance-details-by-resource --resource-type AWS::IAM::User --resource-id "$resource_id"
      ;;
    IAM_ROLE)
      aws configservice get-compliance-details-by-resource --resource-type AWS::IAM::Role --resource-id "$resource_id"
      ;;
    EBS)
      aws configservice get-compliance-details-by-resource --resource-type AWS::EC2::Volume --resource-id "$resource_id"
      ;;
    *)
      echo "Unsupported resource type: $resource_type"
      ;;
  esac
}

# Read and process the resource file
while IFS= read -r line; do
  case "$line" in
    EC2:*)
      resource_type="EC2"
      resource_ids=$(echo "$line" | sed -e 's/EC2: \[//g' -e 's/\]//g' -e 's/", "/\n/g')
      ;;
    S3:*)
      resource_type="S3"
      resource_ids=$(echo "$line" | sed -e 's/S3: \[//g' -e 's/\]//g' -e 's/", "/\n/g')
      ;;
    IAM_USER:*)
      resource_type="IAM_USER"
      resource_ids=$(echo "$line" | sed -e 's/IAM_USER: \[//g' -e 's/\]//g' -e 's/", "/\n/g')
      ;;
    IAM_ROLE:*)
      resource_type="IAM_ROLE"
      resource_ids=$(echo "$line" | sed -e 's/IAM_ROLE: \[//g' -e 's/\]//g' -e 's/", "/\n/g')
      ;;
    EBS:*)
      resource_type="EBS"
      resource_ids=$(echo "$line" | sed -e 's/EBS: \[//g' -e 's/\]//g' -e 's/", "/\n/g')
      ;;
    *)
      continue
      ;;
  esac

  # Debug: Print resource type and extracted IDs
  echo "Resource Type: $resource_type"
  echo "Extracted Resource IDs:"
  echo "$resource_ids"

  # Split resource_ids by newline and loop through each
  for resource_id in $resource_ids; do
    resource_id=$(echo "$resource_id" | tr -d '"')
    if [ -n "$resource_id" ]; then
      check_compliance "$resource_type" "$resource_id"
      echo "---------------------------------------------"
    fi
  done
done < "$RESOURCE_FILE"

