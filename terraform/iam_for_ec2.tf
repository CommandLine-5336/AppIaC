resource "aws_iam_policy" "ec2-to-s3-role" {
  name = "ec2-to-s3-role"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "ObjectGetPut"
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
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
        }, {
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
      }
    ]
  })
}

module "iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.6.1"

  name                    = "ec2-s3-access"
  create_instance_profile = true

  trust_policy_permissions = {
    TrustEC2Service = {
      actions = ["sts:AssumeRole"]
      principals = [{
        type        = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }]
    }
  }


  policies = {
    S3allowsEC2          = aws_iam_policy.ec2-to-s3-role.arn,
    allowSecretManagment = "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    allowSSM             = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = {
    Terraform   = "true"
    Environment = "Dev"
  }
}
