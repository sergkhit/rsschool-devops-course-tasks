resource "aws_key_pair" "epam-tf-ssh-key" {
  key_name   = "rs-tf-ssh-key"
  public_key = var.ssh_key
  tags = {
    Terraform = true
    Project   = var.project
    Owner     = var.user_owner
  }
}