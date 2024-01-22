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

variable "splunk_metrics_endpoint_accesstoken" {
  description = "Access token for Splunk Observability Cloud"
  default     = null
}

variable "splunk_metrics_endpoint_url" {
  description = "Endpoint URL for Splunk Observability Cloud"
  default     = "https://ingest.eu0.signalfx.com/v1/cloudwatch_metric_stream"
}
