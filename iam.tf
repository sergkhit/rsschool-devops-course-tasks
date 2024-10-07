
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

data "template_file" "iam_policy" {
  template = file("${path.module}/iam_policy.json")
  vars = {
    bucket_name = aws_s3_bucket.bucket.bucket
  }
}

resource "aws_iam_policy" "policy" {
  name   = "write-to-tf-rs_task2"
  policy = data.template_file.iam_policy.rendered
  tags = {
    Terraform = "true"
    Project   = var.project
    Owner     = var.user_owner
  }
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "rs_task2-instance-profile"
  role = aws_iam_role.role.name
}