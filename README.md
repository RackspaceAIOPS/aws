# Multi-cloud Terraform Repository

This repository is organized so a Nudgebee runner can clone the repository and execute the Terraform configuration for the target cloud provider.

- `aws/` contains the AWS EC2 implementation.
- `azure/` is reserved for Azure execution code.
- `gcp/` is reserved for GCP execution code.

Run Terraform from the provider-specific directory, for example:

```sh
cd aws
terraform init
terraform apply
```