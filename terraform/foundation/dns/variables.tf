variable "tailscale" {
  type = object({
    api_key = string
    tailnet = string
  })
  sensitive = true
}

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

variable "dns_list" {
  type = list(string)
}
