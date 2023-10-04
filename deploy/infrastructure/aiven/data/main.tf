// Configure Terraform backend
terraform {
  required_version = ">= 1.5.7"

  backend "local" {
    path = "./terraform.tfstate"
  }
}

# Variables
locals {
  service_name           = "${var.aiven_kafka_service_name}-${terraform.workspace}"
  client_truststore_path = "${var.secret_path}/client.truststore.jks"
  client_keystore_path   = "${var.secret_path}/client.keystore.p12"
}

# Data
data "aiven_kafka_user" "kafka_user_avnadmin" {
  service_name = local.service_name
  project      = var.aiven_kafka_project_name
  username     = "avnadmin"
}

data "aiven_kafka" "kafka_service" {
  service_name = local.service_name
  project      = var.aiven_kafka_project_name
}

data "aiven_project" "kafka_project" {
  project = var.aiven_kafka_project_name
}

# Resources
resource "local_sensitive_file" "kafka_user_avnadmin_local_file" {
  content  = <<EOT
{
  "username": "${data.aiven_kafka_user.kafka_user_avnadmin.username}",
  "password": "${data.aiven_kafka_user.kafka_user_avnadmin.password}",
  "access_key": "${base64encode(data.aiven_kafka_user.kafka_user_avnadmin.access_key)}",
  "access_cert": "${base64encode(data.aiven_kafka_user.kafka_user_avnadmin.access_cert)}"
  "ca_cert": "${base64encode(data.aiven_project.kafka_project.ca_cert)}"
  "bootstrap.servers": "${data.aiven_kafka.kafka_service.service_host}:${data.aiven_kafka.kafka_service.service_port}"
  "service_uri": "${data.aiven_kafka.kafka_service.service_uri}"
}
EOT
  filename = "${var.secret_path}/credentials.json"
}

resource "local_sensitive_file" "kafka_user_avnadmin_service_key" {
  content  = data.aiven_kafka_user.kafka_user_avnadmin.access_key
  filename = "${var.secret_path}/service.key"
}

resource "local_sensitive_file" "kafka_user_avnadmin_service_cert" {
  content  = data.aiven_kafka_user.kafka_user_avnadmin.access_cert
  filename = "${var.secret_path}/service.cert"
}

resource "local_sensitive_file" "kafka_project_ca_cert" {
  content  = data.aiven_project.kafka_project.ca_cert
  filename = "${var.secret_path}/ca.pem"
}

# Generate password for Keystore/Truststore
# Usually we must use: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password

# But, here it's OK to output the sensitive key.
resource "random_string" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*-_+?"
}


# Keystore
resource "null_resource" "kafka-client-keystore-p12" {
  provisioner "local-exec" {
    command = <<EOT
      openssl pkcs12 -export -inkey ${var.secret_path}/service.key \
      -in ${var.secret_path}/service.cert \
      -out ${local.client_keystore_path} \
      -name service_key \
      -passin pass:${random_string.password.result} \
      -passout pass:${random_string.password.result}
    EOT
  }
  depends_on = [
    local_sensitive_file.kafka_user_avnadmin_service_key,
    local_sensitive_file.kafka_user_avnadmin_service_cert
  ]
}
# Truststore
resource "null_resource" "kafka-client-truststore-jks" {
  provisioner "local-exec" {
    command = <<EOT
    keytool -import -file ${var.secret_path}/ca.pem \
    -alias CA -keystore ${local.client_truststore_path} \
    -keypass  ${random_string.password.result} \
    -storepass ${random_string.password.result}
    EOT
  }
  depends_on = [local_sensitive_file.kafka_project_ca_cert]
}
