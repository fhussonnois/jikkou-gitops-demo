# Outputs
output "kafka_client_config" {
  value = <<EOT
  security.protocol = "SSL"
  ssl.keystore.location = "${local.client_keystore_path}"
  ssl.keystore.password = "${random_string.password.result}"
  ssl.keystore.type = "PKCS12"
  ssl.truststore.location = "${local.client_truststore_path}"
  ssl.truststore.password = ${random_string.password.result}"
  ssl.key.password = ${random_string.password.result}"
  EOT
}