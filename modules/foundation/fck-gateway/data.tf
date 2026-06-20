data "aws_ssm_parameter" "ts_auth_key" {
  name            = var.ts_auth_key_ssm_path
  with_decryption = true
}
