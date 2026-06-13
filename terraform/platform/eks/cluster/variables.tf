variable "cluster_name" {
  type = string
}

variable "subnet_router_sg" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}
