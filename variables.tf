variable "splunk_observability_cloud_aws_account_id" {
  description = "Account ID for Splunk Observability Cloud"
  default     = ""
}

variable "splunk_observability_cloud_aws_external_id" {
  description = "External ID for Splunk Observability Cloud"
  default     = ""
}

variable "resource_tags" {
  description = "Tags for AWS resources"
  type        = map(string)
  default     = {}
}
