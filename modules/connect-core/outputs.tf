output "queues" {
  value = {
    dl_new_renew = aws_connect_queue.dl_new_renew.id
    vehicle_reg  = aws_connect_queue.vehicle_reg.id
    road_test    = aws_connect_queue.road_test.id
    fines        = aws_connect_queue.fines_citations.id
    general      = aws_connect_queue.general.id
  }
}

output "routing_profile_id" {
  value = aws_connect_routing_profile.dmv_agents.id
}

output "contact_flow_id" {
  value = aws_connect_contact_flow.inbound_main.id
}
