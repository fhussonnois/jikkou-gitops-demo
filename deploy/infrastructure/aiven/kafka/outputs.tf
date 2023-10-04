# Outputs
output "kafka_bootstrap_servers" {
  value = "${aiven_kafka.kafka_service.service_host}:${aiven_kafka.kafka_service.service_port}"
}