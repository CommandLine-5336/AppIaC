module "ec2_role" {
  source = "../modules/iam_role"

  name             = "ec2"
  trusted_services = ["ec2.amazonaws.com"]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]

  inline_policies = {
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "ObjectGetPut"
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
          ]
          Resource = [
            format("arn:aws:s3:::images-bucket-%s-%s-%s/*", var.environment, var.caller_id, var.region),
            format("arn:aws:s3:::security-scan-bucket-%s-%s-%s/*", var.environment, var.caller_id, var.region),
            format("arn:aws:s3:::jenkins-bucket-%s-%s-%s/*", var.environment, var.caller_id, var.region),
          ]
        },
        {
          Sid    = "ListBucket"
          Effect = "Allow"
          Action = [
            "s3:ListBucket"
          ]
          Resource = [
            format("arn:aws:s3:::jenkins-bucket-%s-%s-%s", var.environment, var.caller_id, var.region),
            format("arn:aws:s3:::security-scan-bucket-%s-%s-%s", var.environment, var.caller_id, var.region),
            format("arn:aws:s3:::jenkins-bucket-%s-%s-%s", var.environment, var.caller_id, var.region)
          ]
        },
        {
          Sid    = "ListBuckets"
          Effect = "Allow"
          Action = [
            "s3:ListAllMyBuckets"
          ]
          Resource = ["*"]
        },
        {
          Sid    = "SSM"
          Effect = "Allow"
          Action = [
            "ssm:StartSession",
            "ssm:SendCommand"
          ]
          Resource = ["*"]
        },
        {
          Sid    = "ReadSpecificSecret"
          Effect = "Allow"
          Action = [
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret"
          ]
          Resource = [format("arn:aws:secretsmanager:%s:%s:secret:DatadogAgent/Production-*", var.region, var.caller_id)]
        },
        {
            Sid    = "DescribeEC2"
            Effect = "Allow"
            Action = [
                "ec2:DescribeInstances"
            ]
            Resource = ["*"]
        }
      ]
    })
  }

  create_instance_profile = true

  tags = {
    Environment = var.environment
  }
}