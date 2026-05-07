locals {
  resource_name = "${var.block_ref}-${var.resource_suffix}"
}

# Allows the Nullstone agent to deploy site assets to the S3 bucket and
# invalidate any CloudFront distributions in front of it.

resource "aws_iam_role" "deployer" {
  name               = "deployer-${local.resource_name}"
  tags               = var.tags
  assume_role_policy = data.aws_iam_policy_document.deployer_assume.json
}

data "aws_iam_policy_document" "deployer_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:SetSourceIdentity",
    ]

    principals {
      type        = "AWS"
      identifiers = var.op_assumer_arns
    }
  }
}

resource "aws_iam_role_policy" "deployer" {
  role   = aws_iam_role.deployer.name
  policy = data.aws_iam_policy_document.deployer.json
}

# These actions are necessary to perform 'aws s3 sync' against the site bucket.
data "aws_iam_policy_document" "deployer" {
  statement {
    sid    = "AllowFindBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = [var.bucket_arn]
  }

  statement {
    sid    = "AllowEditObjects"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]
    resources = ["${var.bucket_arn}/*"]
  }

  dynamic "statement" {
    for_each = length(var.cdn_arns) > 0 ? [var.cdn_arns] : []

    content {
      sid       = "AllowCdnUpdate"
      effect    = "Allow"
      resources = statement.value

      actions = [
        "cloudfront:GetDistribution",
        "cloudfront:UpdateDistribution",
        "cloudfront:CreateInvalidation",
        "cloudfront:GetInvalidation",
      ]
    }
  }
}
