# Cola principal (Webhook -> Worker)
resource "aws_sqs_queue" "main" {
  name = "feast-${var.environment}-queue"

  # Tiempo máximo que un mensaje puede vivir
  message_retention_seconds = 86400

  # Tiempo de visibilidad (evita duplicados mientras se procesa)
  visibility_timeout_seconds = 30
}