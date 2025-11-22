resource "aws_dynamodb_table" "config" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "config_key"

  attribute {
    name = "config_key"
    type = "S"
  }

  tags = var.tags
}

# Example items – seed a couple prompts
resource "aws_dynamodb_table_item" "main_menu_en" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = "config_key"
  item = jsonencode({
    config_key = { S = "prompt:main_menu:en" }
    text       = { S = "Welcome to Ambazonia DMV. For Driver Licensing press 1, Vehicle Registration press 2, Road Tests press 3, Fines and Citations press 4, or press 0 to speak to an agent." }
  })
}

resource "aws_dynamodb_table_item" "main_menu_es" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = "config_key"
  item = jsonencode({
    config_key = { S = "prompt:main_menu:es" }
    text       = { S = "Bienvenido al Departamento de Vehículos de Ambazonia..." }
  })
}
