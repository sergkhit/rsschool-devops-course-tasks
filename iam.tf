
resource "aws_iam_group" "group" {
  name = "rs_task2_group"
}

resource "aws_iam_role" "role" {
  name = "rs_task2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
      },
    ]
  })

  tags = {
    Terraform = "true"
    Project   = var.project
    Owner     = var.user_owner

  }
}




# data "template_file" "iam_policy" {
#   template = file("${path.module}/iam_policy.json")
#   vars = {
#     bucket_name = aws_s3_bucket.bucket.bucket
#   }
# }

# resource "aws_iam_policy" "policy" {
#   name   = "write-to-tf-rs_task2"
#   policy = data.template_file.iam_policy.rendered
#   tags = {
#     Terraform = "true"
#     Project   = var.project
#     Owner     = var.user_owner
#   }
# }

# resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
#   role       = aws_iam_role.role.name
#   policy_arn = aws_iam_policy.policy.arn
# }

# resource "aws_iam_instance_profile" "instance_profile" {
#   name = "rs_task2-instance-profile"
#   role = aws_iam_role.role.name
# }

// role for github-actions

resource "aws_iam_role" "role_for_github" {
  assume_role_policy = data.aws_iam_policy_document.github_actions_role_policy.json
  name               = "GithubActionsRole"
}

data "aws_iam_policy_document" "github_actions_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions_IODC_provider.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_username}/${var.github_repo}:*"]
    }
  }
}

# GitHub Actions OIDC Provider -
resource "aws_iam_openid_connect_provider" "github_actions_IODC_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  url             = "https://token.actions.githubusercontent.com"
  thumbprint_list = ["d89e3bd43d5d909b47a18977aa9d5ce36cee184c"]
}


# Policies to the IAM role
resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.role_for_github.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "route53_full_access" {
  role       = aws_iam_role.role_for_github.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.role_for_github.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "iam_full_access" {
  role       = aws_iam_role.role_for_github.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "vpc_full_access" {
  role       = aws_iam_role.role_for_github.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_role_policy_attachment" "sqs_full_access" {
  role       = aws_iam_role.role_for_github.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "eventbridge_full_access" {
  role       = aws_iam_role.role_for_github.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
}
