# ==================================================================================================
# IAM role for Splunk Observability Cloud metadata collector

data "aws_iam_policy_document" "env_splunk_observability_cloud_collector_trust_policy" {
  statement {
    sid     = "AllowStsAssumeRoleForSplunkObservabilityCloudCollector"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["${var.splunk_observability_cloud_aws_account_id}"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["${local.account_id}"]
    }
  }
}

# Kinesis Data Firehose uses this IAM role for all the permissions that the delivery stream needs
resource "aws_iam_role" "env_splunk_observability_cloud_collector" {
  name = "${lower(local.env)}-splunk-observability-cloud-collector"

  assume_role_policy = data.aws_iam_policy_document.env_splunk_observability_cloud_collector_trust_policy.json

  tags = merge(
    var.resource_tags,
    {
      Environment = local.env
    }
  )
}

# Enable Splunk Observability Cloud role to Access service metadata for many things
data "aws_iam_policy_document" "env_splunk_observability_cloud_collector" {

  statement {
    sid    = "AllowMultipleServiceReadForSplunkObservabilityCloudCollector"
    effect = "Allow"
    actions = [
      "apigateway:GET",
      "autoscaling:DescribeAutoScalingGroups",
      "cloudformation:ListResources",
      "cloudformation:GetResource",
      "cloudfront:GetDistributionConfig",
      "cloudfront:ListDistributions",
      "cloudfront:ListTagsForResource",
      "cloudwatch:DescribeAlarms",
      "directconnect:DescribeConnections",
      "dynamodb:DescribeTable",
      "dynamodb:ListTables",
      "dynamodb:ListTagsOfResource",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeNatGateways",
      "ec2:DescribeRegions",
      "ec2:DescribeReservedInstances",
      "ec2:DescribeReservedInstancesModifications",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ecs:DescribeClusters",
      "ecs:DescribeServices",
      "ecs:DescribeTasks",
      "ecs:ListClusters",
      "ecs:ListServices",
      "ecs:ListTagsForResource",
      "ecs:ListTaskDefinitions",
      "ecs:ListTasks",
      "eks:DescribeCluster",
      "eks:ListClusters",
      "elasticache:DescribeCacheClusters",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticmapreduce:DescribeCluster",
      "elasticmapreduce:ListClusters",
      "es:DescribeElasticsearchDomain",
      "es:ListDomainNames",
      "kinesis:DescribeStream",
      "kinesis:ListShards",
      "kinesis:ListStreams",
      "kinesis:ListTagsForStream",
      "kinesisanalytics:ListApplications",
      "kinesisanalytics:DescribeApplication",
      "kinesisanalytics:ListTagsForResource",
      "lambda:GetAlias",
      "lambda:ListFunctions",
      "lambda:ListTags",
      "logs:DeleteSubscriptionFilter",
      "logs:DescribeLogGroups",
      "logs:DescribeSubscriptionFilters",
      "logs:PutSubscriptionFilter",
      "organizations:DescribeOrganization",
      "rds:DescribeDBInstances",
      "rds:DescribeDBClusters",
      "rds:ListTagsForResource",
      "redshift:DescribeClusters",
      "redshift:DescribeLoggingStatus",
      "s3:GetBucketLocation",
      "s3:GetBucketLogging",
      "s3:GetBucketNotification",
      "s3:GetBucketTagging",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:PutBucketNotification",
      "sqs:GetQueueAttributes",
      "sqs:ListQueues",
      "sqs:ListQueueTags",
      "states:ListActivities",
      "states:ListStateMachines",
      "tag:GetResources",
      "workspaces:DescribeWorkspaces"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowCassandraSelectForSplunkObservabilityCloudCollector"
    effect = "Allow"
    actions = [
      "cassandra:Select"
    ]
    resources = [
      "arn:aws:cassandra:*:*:/keyspace/system/table/local",
      "arn:aws:cassandra:*:*:/keyspace/system/table/peers",
      "arn:aws:cassandra:*:*:/keyspace/system_schema/*",
      "arn:aws:cassandra:*:*:/keyspace/system_schema_mcs/table/tags",
      "arn:aws:cassandra:*:*:/keyspace/system_schema_mcs/table/tables",
      "arn:aws:cassandra:*:*:/keyspace/system_schema_mcs/table/columns"
    ]
  }
}

resource "aws_iam_policy" "env_splunk_observability_cloud_collector" {
  name        = "SplunkObservabilityCloudCollector"
  description = "Policy granting Kinesis Firehose permissions"
  policy      = data.aws_iam_policy_document.env_splunk_observability_cloud_collector.json
}

resource "aws_iam_role_policy_attachment" "env_splunk_observability_cloud_collector" {
  role       = aws_iam_role.env_splunk_observability_cloud_collector.name
  policy_arn = aws_iam_policy.env_splunk_observability_cloud_collector.arn
}

# ==================================================================================================
# IAM role for Kinesis delivery stream

data "aws_iam_policy_document" "env_splunk_metrics_kinesis_service_trust_policy" {
  statement {
    sid     = "AllowStsAssumeRoleForFirehose"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["${local.account_id}"]
    }
  }
}

# Kinesis Data Firehose uses this IAM role for all the permissions that the delivery stream needs
resource "aws_iam_role" "env_splunk_metrics_kinesis_service" {
  name = "${lower(local.env)}-splunk-metrics-kinesis-service"

  assume_role_policy = data.aws_iam_policy_document.env_splunk_metrics_kinesis_service_trust_policy.json

  tags = merge(
    var.resource_tags,
    {
      Environment = local.env
    }
  )
}

# Enable Kinesis Data Firehose role to Access the S3 bucket for data backup and CloudWatch for error logging
data "aws_iam_policy_document" "env_splunk_metrics_kinesis_service" {

  statement {
    sid    = "AllowFirehoseWriteCloudwatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/kinesisfirehose/${aws_kinesis_firehose_delivery_stream.env_splunk_metrics_delivery_stream.name}:*"
    ]
  }

  statement {
    sid    = "AllowFirehoseWriteS3"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
      "s3:PutObjectAcl" # Note: Extra grant, allows the role to set s3 object ownership to the bucket owner
    ]
    resources = [
      "${aws_s3_bucket.ob_env_splunk_metrics_record_backup.arn}",
      "${aws_s3_bucket.ob_env_splunk_metrics_record_backup.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "env_splunk_metrics_kinesis_service" {
  name        = "SplunkMetricsKinesisServicePolicy"
  description = "Policy granting Kinesis Firehose permissions"
  policy      = data.aws_iam_policy_document.env_splunk_metrics_kinesis_service.json
}

resource "aws_iam_role_policy_attachment" "env_splunk_metrics_kinesis_service" {
  role       = aws_iam_role.env_splunk_metrics_kinesis_service.name
  policy_arn = aws_iam_policy.env_splunk_metrics_kinesis_service.arn
}

# ==================================================================================================
# S3 Bucket for storing CloudWatch metrics backup data

resource "aws_s3_bucket" "env_splunk_metrics_record_backup" {
  bucket        = "${lower(local.env)}-splunk-metrics-record-backup"
  force_destroy = false

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    var.resource_tags,
    {
      Environment = local.env
    }
  )
}

data "aws_iam_policy_document" "env_splunk_metrics_record_backup" {
  statement {
    sid     = "EnforceHttpsForAllAccess"
    effect  = "Deny"
    actions = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.env_splunk_metrics_record_backup.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "env_splunk_metrics_record_backup" {
  bucket = aws_s3_bucket.env_splunk_metrics_record_backup.id
  policy = data.aws_iam_policy_document.env_splunk_metrics_record_backup.json
}

# ==================================================================================================
# Kinesis Firehose Delivery Stream

resource "aws_cloudwatch_log_group" "env_splunk_metrics_delivery_stream" {
  name              = "/aws/kinesisfirehose/${lower(local.env)}-splunk-metrics-delivery-stream"
  retention_in_days = 30

  tags = merge(
    var.resource_tags,
    {
      Environment = local.env
    }
  )
}

resource "aws_kinesis_firehose_delivery_stream" "env_splunk_metrics_delivery_stream" {
  name        = "${lower(local.env)}-splunk-metrics-delivery-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.env_splunk_metrics_kinesis_service.arn
    bucket_arn         = aws_s3_bucket.env_splunk_metrics_record_backup.arn
    buffer_size        = 5
    buffer_interval    = 300
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${lower(local.env)}-splunk-metrics-delivery-stream"
      log_stream_name = "HttpEndpointDelivery"
    }
  }

  http_endpoint_configuration {
    name               = "splunk_cloud_eu_metrics_endpoint"
    url                = var.splunk_metrics_endpoint_url
    access_key         = var.splunk_metrics_endpoint_accesstoken
    buffering_size     = 1
    buffering_interval = 60
    role_arn           = aws_iam_role.env_splunk_metrics_kinesis_service.arn
    s3_backup_mode     = "FailedDataOnly"

    request_configuration {
      content_encoding = "GZIP"
    }
  }

  server_side_encryption {
    enabled = false
  }
}

# ==================================================================================================
# IAM role for CloudWatch metric stream

data "aws_iam_policy_document" "env_splunk_metrics_collection_service_trust_policy" {
  statement {
    sid     = "AllowStsAssumeRoleForAWSCloudWatchMetricStreams"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["streams.metrics.cloudwatch.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["${local.account_id}"]
    }
  }
}

resource "aws_iam_role" "env_splunk_metrics_collection_service" {
  name               = "${lower(local.env)}-splunk-metrics-collection-service"
  assume_role_policy = data.aws_iam_policy_document.env_splunk_metrics_collection_service_trust_policy.json
}

# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-metric-streams-trustpolicy.html
data "aws_iam_policy_document" "env_splunk_metrics_collection_service" {
  statement {
    sid    = "AllowFirehosePutPermissions"
    effect = "Allow"
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch",
    ]
    resources = [aws_kinesis_firehose_delivery_stream.env_splunk_metrics_delivery_stream.arn]
  }
}

resource "aws_iam_role_policy" "env_splunk_metrics_collection_service" {
  name   = "${lower(local.env)}-splunk-metrics-collection-service"
  role   = aws_iam_role.env_splunk_metrics_collection_service.id
  policy = data.aws_iam_policy_document.env_splunk_metrics_collection_service.json
}

# CloudWatch metric stream
resource "aws_cloudwatch_metric_stream" "env_splunk_metrics_collection_stream" {
  name          = "${lower(local.env)}-splunk-metrics-collection-stream"
  role_arn      = aws_iam_role.env_splunk_metrics_collection_service.arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.env_splunk_metrics_delivery_stream.arn
  output_format = "opentelemetry0.7"

  # Filters for specific metric namespaces and names to include
  include_filter {
    namespace    = "Directory"
    metric_names = ["200", "ServiceStatus"]
  }

  include_filter {
    namespace    = "AWS/CertificateManager"
    metric_names = ["DaysToExpiry"]
  }

  include_filter {
    namespace    = "AWS/ApplicationELB"
    metric_names = ["HealthyHostCount", "UnHealthyHostCount"]
  }
}
