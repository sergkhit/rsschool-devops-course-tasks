provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["%USERPROFILE%/.aws/config"]
  shared_credentials_files = ["%USERPROFILE%/.aws/credentials"]
  profile                  = "default"
}

# resource "aws_iam_role" "GithubActionsRole" {
#   name = "GithubActionsRole"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Type": "Service",
#         "Identifiers": ["actions.amazonaws.com"]
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF

#   managed_policy_arns = [
#     "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
#     "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
#     "arn:aws:iam::aws:policy/AmazonS3FullAccess",
#     "arn:aws:iam::aws:policy/IAMFullAccess",
#     "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
#     "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
#     "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
#   ]
# }
