output "gateway_security_groups_ids" {
  description = "List of security group IDs attached to the fck-nat gateway instances"
  value       = module.fck-gateway.security_group_ids
}
