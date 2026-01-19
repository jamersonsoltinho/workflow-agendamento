terraform {
  required_version = ">= 1.3.0"
}

variable "telegram_bot_token" {
  type        = string
  description = "Token do bot do Telegram"
}

variable "chat_id" {
  type        = string
  description = "ID do chat do Telegram"
}

locals {
  message_text = "Mensagem enviada via Terraform em ${formatdate("DD/MM/YYYY", timestamp())} às ${formatdate("hh:mm:ss", timestamp())}."
}

resource "null_resource" "send_telegram_message" {

  triggers = {
    # força reexecução se a mensagem mudar
    message = local.message_text
  }

  provisioner "local-exec" {
    command = <<EOT
curl -s -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "chat_id": "${var.chat_id}",
    "text": "${local.message_text}"
  }' \
  https://api.telegram.org/bot${var.telegram_bot_token}/sendMessage
EOT
  }
}
