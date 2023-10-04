# Variables for providers.tf
variable "aiven_api_token" {
  description = "Aiven - API Token"
  type        = string
  sensitive = true
}

# Variables for kafka.tf
variable "aiven_kafka_project_name" {
  description = "Aiven - The project name"
  type        = string
  sensitive = true
}

variable "aiven_kafka_service_name" {
  description = "Aiven - The service name for Apache Kafka"
  type        = string
  sensitive = true
  default = "kafka-service"
}

variable "aiven_kafka_plan" {
  description = "The plan"
  type        = string
  default = "startup-2"
}

variable "aiven_kafka_cloud_name" {
  description = "The Cloud name"
  type        = string
  default = "google-europe-west1"
}

variable "aiven_kafka_service_version" {
  description = "Kafka version"
  type        = string
  default = "3.5"
}