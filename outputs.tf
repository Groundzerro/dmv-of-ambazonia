output "dmv_queue_ids" {
  value = module.connect_core.queues
}

output "dmv_routing_profile_id" {
  value = module.connect_core.routing_profile_id
}

output "dmv_contact_flow_id" {
  value = module.connect_core.contact_flow_id
}
