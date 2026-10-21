Baseline IaC Security Scan

- Tool: Trivy
- Target: `tests/fixtures/insecure-s3`
- Result: 5 misconfigurations reported
- Purpose: Establish a baseline using an intentionally insecure Terraform fixture before implementing security controls.
- Evidence: `evidence/scan-results/insecure-s3.json` and `evidence/screenshots/02-insecure-test/04-initial-trivy-findings.png`
- Next step: Review the individual findings and implement appropriate security controls in the production Terraform configuration.
- Safety: The insecure fixture is for testing only and must never be deployed.
S3 Security Remediation — Initial Results

Objective: Address S3 public-access and encryption misconfigurations identified during the baseline scan.

Changes implemented:
- Blocked public ACLs.
- Blocked public bucket policies.
- Enabled ignoring public ACLs.
- Restricted public bucket policies.
- Configured SSE-KMS using an explicitly referenced customer-managed KMS key.
- Enabled S3 bucket versioning.
- Enabled KMS key rotation in the Terraform configuration.

Validation results:
- Terraform validation: Passed.
- Trivy HIGH/CRITICAL findings: 0 in the hardened Terraform directory.
- AWS deployment: Not performed.
- Cloud expenditure: No infrastructure deployed.

Evidence:
- Initial findings: `evidence/scan-results/insecure-s3.json`
- Remediated configuration: `evidence/scan-results/secure-s3.json`
- Screenshot: `evidence/screenshots/03-remediation/02-clean-scan.png`

Limitations: A clean scan for HIGH and CRITICAL findings does not establish complete security or regulatory compliance. Further checks, control mapping and testing are required.
Regression Test — Scanner Detection Confirmed

Test objective: Verify that Trivy detects known misconfigurations in an intentionally insecure Terraform fixture.

Insecure fixture result: 5 HIGH findings.
- AWS-0086 — Public ACLs not blocked.
- AWS-0087 — Public bucket policies not blocked.
- AWS-0091 — Public ACLs not ignored.
- AWS-0093 — Public bucket policies not restricted.
- AWS-0132 — Customer-managed KMS encryption not configured.

Hardened configuration result: 0 HIGH/CRITICAL findings in the tested configuration.

Conclusion: Trivy detected the expected misconfigurations in the insecure fixture. The hardened configuration passed the selected severity filter. This does not prove complete security or compliance.

AWS deployment: Not performed.