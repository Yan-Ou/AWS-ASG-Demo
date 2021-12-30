resource "tls_private_key" "private_ssh_key" {
  algorithm   = "RSA"
}

resource "aws_key_pair" "deployer" {
  key_name    = "${var.project_name}-ssh-key"
  public_key  = tls_private_key.private_ssh_key.public_key_openssh
  tags        = local.common_tags
}

resource "aws_s3_bucket_object" "private_key_object" {
  bucket = var.terraform_state_s3_bucket
  key    = var.private_key_filename
  content = tls_private_key.private_ssh_key.private_key_pem
}
