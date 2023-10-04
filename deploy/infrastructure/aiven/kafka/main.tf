// Configure Terraform backend
terraform {
  required_version = ">= 1.5.7"

  backend "local" {
    path = "./terraform.tfstate"
  }
}

# Variables
locals {}

# Data

# Resource
resource "aiven_kafka" "kafka_service" {
  project                 = var.aiven_kafka_project_name
  cloud_name              = var.aiven_kafka_cloud_name
  plan                    = var.aiven_kafka_plan
  service_name            = "${var.aiven_kafka_service_name}-${terraform.workspace}"
  maintenance_window_dow  = "monday"
  maintenance_window_time = "10:00:00"

  kafka_user_config {
    // Enables Kafka Schemas
    schema_registry = true
    kafka_connect   = false
    kafka_rest      = false
    // Kafka Service version
    kafka_version   = var.aiven_kafka_service_version
    kafka {
      // Kafka custom configuration settings
    }
  }
}
