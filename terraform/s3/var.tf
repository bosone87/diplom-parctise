# YC account

variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}
variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}
variable "bucket_name" {
  type = string
  default = "tfstate-diplom"
}

# YC zones

variable "default_region" {
  type        = string
  default     = "ru-central1"
}
variable "vms_zone" {
  type        = string
  default     = "standard-v1"
}
variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}