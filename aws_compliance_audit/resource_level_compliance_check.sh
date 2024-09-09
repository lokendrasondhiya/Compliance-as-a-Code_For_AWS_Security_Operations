#!/bin/bash

# Function to check compliance for a given resource type
check_compliance() {
  resource_type=$1
  resource_id=$2

  echo "Checking compliance for $resource_type with ID: $resource_id"

  case "$resource_type" in
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

# Hardcoded S3 bucket compliance check
s3_bucket_id="config-bucket-103397705298"
check_compliance "S3" "$s3_bucket_id"

# Hardcoded IAM Users compliance check
iam_users=("new_user1" "new_user2" "user1" "user2")
for user in "${iam_users[@]}"; do
  check_compliance "IAM_USER" "$user"
done

# Hardcoded IAM Roles compliance check
iam_roles=("AWSServiceRoleForConfig" "AWSServiceRoleForSupport" "AWSServiceRoleForTrustedAdvisor" "CustomAdminRole")
for role in "${iam_roles[@]}"; do
  check_compliance "IAM_ROLE" "$role"
done

# Hardcoded EBS volumes compliance check
ebs_volumes=("vol-0a7303050db6e0db1" "vol-0ca4f2bf6dc0f8891")
for volume in "${ebs_volumes[@]}"; do
  check_compliance "EBS" "$volume"
done

