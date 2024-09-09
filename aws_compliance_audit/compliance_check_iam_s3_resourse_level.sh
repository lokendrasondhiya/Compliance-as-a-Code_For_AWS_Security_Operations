#!/bin/bash

PROFILE="default"

# Function to check compliance for a given resource type and resource ID
check_compliance() {
  resource_type=$1
  resource_id=$2
  echo "Checking compliance for $resource_type with ID: $resource_id"
  
  # Fetch compliance details for the resource
  compliance_result=$(aws configservice get-compliance-details-by-resource \
    --resource-type "$resource_type" \
    --resource-id "$resource_id" \
    --query 'EvaluationResults[*].ComplianceType' \
    --output text --profile $PROFILE)

  # Handle cases where the compliance status is not evaluated
  if [ -z "$compliance_result" ]; then
    echo "Compliance Status: NOT EVALUATED or COMPLIANT by Default"
  else
    echo "Compliance Status: $compliance_result"
  fi
  echo "---------------------------------------------"
}

# Check compliance for IAM Users
echo "Checking Compliance for IAM Users..."
iam_users=$(aws iam list-users --query "Users[*].UserName" --output text --profile $PROFILE)
for user in $iam_users; do
  check_compliance "AWS::IAM::User" "$user"
done

# Check compliance for IAM Roles
echo "Checking Compliance for IAM Roles..."
iam_roles=$(aws iam list-roles --query "Roles[*].RoleName" --output text --profile $PROFILE)
for role in $iam_roles; do
  check_compliance "AWS::IAM::Role" "$role"
done

# Check compliance for S3 Buckets
echo "Checking Compliance for S3 Buckets..."
s3_buckets=$(aws s3api list-buckets --query "Buckets[*].Name" --output text --profile $PROFILE)
for bucket in $s3_buckets; do
  check_compliance "AWS::S3::Bucket" "$bucket"
done

echo "Compliance check completed."

