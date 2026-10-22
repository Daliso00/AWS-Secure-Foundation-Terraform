# Secure AWS Foundation with Terraform

**A cybersecurity portfolio project focused on secure-by-default AWS infrastructure, Infrastructure as Code (IaC), and automated misconfiguration detection.**

## Project Overview

This project demonstrates how to define a security-focused AWS S3 evidence bucket using Terraform and test the configuration with Trivy.

The goal is to identify common cloud misconfigurations, apply preventive security controls in code, and preserve evidence of the testing process.

**Important:** This project was validated locally. No AWS infrastructure was deployed, and the configuration has not been verified against a live AWS account.

## Objectives

- Define AWS infrastructure using Terraform.
- Apply security controls to an S3 evidence bucket.
- Detect insecure configurations using Trivy.
- Compare findings from an intentionally insecure test fixture against the hardened configuration.
- Maintain reproducible configuration and documented test evidence in Git.

## Tools Used

| Tool | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| AWS provider | Defines AWS resource configurations |
| Trivy | Infrastructure misconfiguration scanning |
| Git | Version control |
| GitHub | Source code and portfolio hosting |
| PowerShell | Local command-line workflow |

## Security Controls

The Terraform configuration defines the following controls:

- **S3 public access restrictions:** enables all four S3 Block Public Access settings.
- **Server-side encryption:** configures AWS KMS encryption with a customer-managed KMS key.
- **Key rotation configuration:** enables automatic rotation in the KMS key configuration.
- **Bucket versioning:** enables versioning to help preserve object history.
- **Resource management:** sets `force_destroy = false` to avoid configuring routine Terraform destruction to empty the bucket automatically.
- **Resource tagging:** adds project and management metadata.

These are controls defined in code. Their effectiveness in a deployed AWS environment has not yet been tested.

## Testing and Results

### 1. Insecure configuration

An intentionally insecure S3 bucket fixture is stored in:

`tests/fixtures/insecure-s3/main.tf`

Trivy detected five HIGH findings in the initial test. The findings concerned public-access protections and customer-managed encryption requirements.

The fixture is retained as a regression test and must not be deployed.

### 2. Hardened configuration

The proposed secure configuration is stored in:

`terraform/main.tf`

Terraform validation succeeded locally. Trivy reported zero HIGH or CRITICAL findings for the hardened configuration under the scan scope used.

A clean static scan does not prove that a configuration is completely secure or compliant. It means the scanner did not detect findings at the selected severity levels in that scan.

### 3. Evidence

Supporting evidence is stored in:

- `evidence/scan-results/` — JSON scan reports.
- `evidence/screenshots/01-environment/` — development environment evidence.
- `evidence/screenshots/02-insecure-test/` — insecure fixture and initial findings.
- `evidence/screenshots/03-remediation/` — remediation and clean scan evidence.

## Repository Structure

```text
.
├── docs/
│   └── project-log.md
├── evidence/
│   ├── scan-results/
│   └── screenshots/
├── terraform/
│   ├── main.tf
│   └── .terraform.lock.hcl
├── tests/
│   └── fixtures/
│       └── insecure-s3/
│           └── main.tf
├── .gitignore
└── README.md
```

## Run the Local Checks

Install Terraform and Trivy first. From the repository root, initialize the Terraform working directory without configuring a backend:

```powershell
terraform -chdir=terraform init -backend=false
```

Validate the configuration:

```powershell
terraform -chdir=terraform validate
```

Scan the hardened configuration:

```powershell
trivy config --severity HIGH,CRITICAL .\terraform
```

Scan the intentionally insecure fixture:

```powershell
trivy config --severity HIGH,CRITICAL .\tests\fixtures\insecure-s3
```

The insecure fixture should produce findings. Exact results may vary with Trivy versions and policy updates.

**Do not run `terraform apply` for this local-only project.** The test fixture is deliberately insecure and must never be deployed.

## Current Limitations

- No AWS resources have been deployed.
- IAM permissions and live AWS account configuration have not been tested.
- Encryption, key rotation, versioning, and public-access controls have not been verified against a live bucket.
- No CI/CD security pipeline has been implemented yet.
- The results reflect local static analysis, not a full security audit.

## Future Improvements

- Add GitHub Actions for automated Terraform validation and Trivy scanning.
- Add automated regression checks that confirm the insecure fixture is detected.
- Map implemented controls to relevant AWS security best practices.
- Document expected scan outcomes and troubleshooting steps.
- Consider a controlled AWS deployment when an appropriate budget and test environment are available.

## Learning Outcomes

This project demonstrates practical experience with Infrastructure as Code, cloud security configuration, static misconfiguration scanning, evidence collection, and version control.

The next phase will focus on automating security checks in a CI/CD pipeline.

---

**Project:** Secure AWS Foundation with Terraform  
**Focus:** Cloud Security | Infrastructure as Code | DevSecOps  
**Status:** Local validation and static scanning completed; live deployment not performed.
