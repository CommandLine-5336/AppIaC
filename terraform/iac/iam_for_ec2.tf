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
            "arn:aws:s3:::images-bucket-704427427594-us-east-1/*",
            "arn:aws:s3:::security-scan-bucket-704427427594-us-east-1/*",
            "arn:aws:s3:::jenkins-bucket-704427427594-us-east-1/*"
          ]
        },
        {
          Sid    = "ListBucket"
          Effect = "Allow"
          Action = [
            "s3:ListBucket"
          ]
          Resource = [
            "arn:aws:s3:::images-bucket-704427427594-us-east-1",
            "arn:aws:s3:::security-scan-bucket-704427427594-us-east-1",
            "arn:aws:s3:::jenkins-bucket-704427427594-us-east-1"
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
          Resource = ["arn:aws:secretsmanager:us-east-1:704427427594:secret:DatadogAgent/Production-*"]
        }
      ]
    })
  }

  create_instance_profile = true

  tags = {
    Environment = "Dev"
  }
}