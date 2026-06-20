variable "ts_auth_key_ssm_path" {
  description = "AWS SSM Parameter Store path for the Tailscale authentication key"
  type        = string
  sensitive   = true
}

variable "vpc" {
  description = "VPC configuration including VPC ID, CIDR block, private route table IDs, and public subnet IDs"
  type = object({
    vpc_id                  = string
    vpc_cidr                = string
    private_route_table_ids = list(string)
    public_subnet_ids       = list(string)
  })
}
