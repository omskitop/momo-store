terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.87.0"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "terraform-state-momo-store-std-032-63"
    key      = "terraform.tfstate"
    region   = "ru-central1"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id # Set your cloud ID
  folder_id = var.folder_id # Set your cloud folder ID
  zone      = var.zone # Availability zone by default, one of ru-central1-a, ru-central1-b, ru-central1-c
}