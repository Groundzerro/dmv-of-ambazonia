resource "time_sleep" "wait_for_hours" {
  depends_on      = [aws_connect_hours_of_operation.dmv_hours]
  create_duration = "20s"
}

resource "aws_connect_hours_of_operation" "dmv_hours" {
  instance_id = var.instance_id
  name        = "${var.project_name}-hours"
  description = "Ambazonia DMV hours"
  time_zone   = var.hours_timezone

  # Monday–Friday 8am–5pm
  dynamic "config" {
    for_each = [
      "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY"
    ]
    content {
      day = config.value

      start_time {
        hours   = 8
        minutes = 0
      }

      end_time {
        hours   = 17
        minutes = 0
      }
    }
  }
}

resource "aws_connect_queue" "dl_new_renew" {
  instance_id           = var.instance_id
  name                  = "DL-NEW-RENEW"
  description           = "Driver licensing new and renewals"
  hours_of_operation_id = aws_connect_hours_of_operation.dmv_hours.id

  depends_on = [time_sleep.wait_for_hours]
}

resource "aws_connect_queue" "vehicle_reg" {
  instance_id           = var.instance_id
  name                  = "VEHICLE-REG"
  description           = "Vehicle registration and plates"
  hours_of_operation_id = aws_connect_hours_of_operation.dmv_hours.id

  depends_on = [time_sleep.wait_for_hours]
}

resource "aws_connect_queue" "road_test" {
  instance_id           = var.instance_id
  name                  = "ROAD-TEST"
  description           = "Road test scheduling"
  hours_of_operation_id = aws_connect_hours_of_operation.dmv_hours.id

  depends_on = [time_sleep.wait_for_hours]
}

resource "aws_connect_queue" "fines_citations" {
  instance_id           = var.instance_id
  name                  = "FINES-CITATIONS"
  description           = "Fines, citations, suspensions"
  hours_of_operation_id = aws_connect_hours_of_operation.dmv_hours.id

  depends_on = [time_sleep.wait_for_hours]
}

resource "aws_connect_queue" "general" {
  instance_id           = var.instance_id
  name                  = "GENERAL-INQUIRY"
  description           = "General inquiries / operator"
  hours_of_operation_id = aws_connect_hours_of_operation.dmv_hours.id

  depends_on = [time_sleep.wait_for_hours]
}

resource "aws_connect_routing_profile" "dmv_agents" {
  instance_id = var.instance_id
  name        = "${var.project_name}-DMV-AGENTS"
  description = "Routing profile for DMV agents"

  default_outbound_queue_id = aws_connect_queue.general.id

  media_concurrencies {
    channel     = "VOICE"
    concurrency = 1
  }

  queue_configs {
    channel  = "VOICE"
    delay    = 0
    priority = 1
    queue_id = aws_connect_queue.dl_new_renew.id
  }

  queue_configs {
    channel  = "VOICE"
    delay    = 0
    priority = 1
    queue_id = aws_connect_queue.vehicle_reg.id
  }

  queue_configs {
    channel  = "VOICE"
    delay    = 0
    priority = 1
    queue_id = aws_connect_queue.road_test.id
  }

  queue_configs {
    channel  = "VOICE"
    delay    = 0
    priority = 1
    queue_id = aws_connect_queue.fines_citations.id
  }

  queue_configs {
    channel  = "VOICE"
    delay    = 0
    priority = 1
    queue_id = aws_connect_queue.general.id
  }
}

resource "aws_connect_lambda_function_association" "config_lambda" {
  instance_id  = var.instance_id
  function_arn = var.lambda_arn
}

resource "aws_connect_contact_flow" "inbound_main" {
  instance_id = var.instance_id
  name        = "${var.project_name}-Inbound-Main"
  description = "Inbound main DMV flow using Lambda + DynamoDB config"
  type        = "CONTACT_FLOW"

  content = file("${path.module}/templates/inbound_main_flow.json")
}

# resource "aws_connect_phone_number" "dmv_number" {
#   type         = "DID"          # or TOLL_FREE
#   country_code = "US"
#   target_arn   = aws_connect_contact_flow.inbound_main.arn
#   description  = "Ambazonia DMV main number"

#   tags = {
#     Project     = var.project_name
#     Environment = "dev"
#   }
# }
