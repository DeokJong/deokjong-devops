variable "remote_state_bucket" {
  type      = string
  sensitive = true
}

variable "remote_state_region" {
  type      = string
  sensitive = true
}

variable "foundation_vpc_state_key" {
  type      = string
  sensitive = true
}

variable "foundation_fck_gateway_state_key" {
  type      = string
  sensitive = true
}
