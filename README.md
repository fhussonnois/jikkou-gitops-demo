# GitOps & Kafka: Enabling smooth and seamless Data Schema management with Jikkou and GitHub Actions

## Hands-on

📢 Blog post: https://medium.com/@fhussonnois/gitops-kafka-enabling-smooth-and-seamless-data-schema-management-with-jikkou-and-github-actions-d920a6a14bb

## Infrastructure

This repository use Terraform to manage Apache Kafka and Schema Registry services on [Aiven](https://aiven.io/kafka). 

To configure required variables:

```hcl
# file: variables.tfvars
aiven_api_token = "<Aiven_Token>"
aiven_kafka_project_name = "<Your_Project_Name>"
```

To create Kafka Service:

```bash
cd ./deploy/intrastructure/aiven/kafka
terraform init
terraform plan -var-file=path/to/variables.tfvars
terraform apply -var-file=path/to/variables.tfvars
```

To destroy Kafka Service: 

```bash
cd ./deploy/intrastructure/aiven/kafka
terraform destroy -var-file=path/to/variables.tfvars
```

To get Kafka client Keystore/Truststore

```bash
cd ./deploy/intrastructure/aiven/data
terraform init
terraform plan -var-file=path/to/variables.tfvars
terraform apply -var-file=path/to/variables.tfvars
```

## License

This code base is available under the Apache License, version 2.