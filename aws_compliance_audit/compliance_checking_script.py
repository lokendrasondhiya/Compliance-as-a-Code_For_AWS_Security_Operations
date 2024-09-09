import json

def check_compliance(iam_policy):
    # Load CIS benchmarks criteria here or directly hard-code them for simplicity
    # Example: All roles should have MFA enabled, no wide-open S3 permissions, etc.
    compliance_issues = []
    # Check each policy statement
    for statement in iam_policy.get('Statement', []):
        if statement['Effect'] == 'Allow' and statement['Action'] == '*':
            compliance_issues.append("Policy allows all actions: Potential security risk.")
    return compliance_issues

# Example use:
with open('iam_policy.json', 'r') as f:
    iam_policy = json.load(f)

issues = check_compliance(iam_policy)
if issues:
    print("Compliance Issues Found:")
    for issue in issues:
        print(issue)
else:
    print("No Compliance Issues Found.")

