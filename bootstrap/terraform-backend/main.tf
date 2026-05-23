module "s3_backend_state" {
  source = "DeokJong/s3-terraform-state/aws"

  create_bucket = true
  bucket_name   = var.backend_state_bucket_name
}
