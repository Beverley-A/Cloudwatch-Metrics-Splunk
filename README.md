# Cloudwatch-Metrics-Splunk

Enable the integration of specific CloudWatch metrics into Splunk Observability Cloud through Terraform Cloud.

## Terraform AWS Infrastructure for Splunk Observability Cloud

This repository provides Terraform code to set up AWS infrastructure for seamless integration with Splunk Observability Cloud. The infrastructure includes IAM roles, policies, S3 buckets, Kinesis Firehose Delivery Stream, and CloudWatch Metric Streams.

## Prerequisites

Before you begin, make sure you have the following:

- [Terraform](https://www.terraform.io/) installed locally.
- AWS CLI configured with appropriate credentials.

## Getting Started

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your-username/terraform-splunk-observability.git
   cd terraform-splunk-observability

## GitHub Actions
This repository is configured with GitHub Actions to automate Terraform deployments. The workflow triggers on every push to the main branch.

Ensure you set up the following secrets in your GitHub repository:

SPLUNK_OBSERVABILITY_CLOUD_ACCOUNT_ID: Splunk Observability Cloud account ID.
SPLUNK_OBSERVABILITY_CLOUD_EXTERNAL_ID: External ID for Splunk Observability Cloud.

## Terraform Modules
cloud-metrics.tf: Defines IAM roles, policies, S3 bucket, Kinesis Firehose Delivery Stream, and CloudWatch Metric Streams.
variables.tf: Declares Terraform variables used in the configuration.

## Cleanup
To destroy the infrastructure and resources created by Terraform, run:
terraform destroy -auto-approve

## Contributions
Contributions are welcome! If you find issues or have suggestions, feel free to open an issue or create a pull request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

This version includes improved formatting, clear instructions, and additional details to make it more user-friendly. Adjust the placeholders, such as `your-username`, and update the content as needed for your specific project.
