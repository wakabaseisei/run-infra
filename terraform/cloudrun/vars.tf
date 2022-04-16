variable "location" {
  default = "asia-northeast1-a"
}

variable "region" {
  type        = string
  default     = "asia-northeast1"
  description = "GCP Project Default Region"
}


variable "cloud_sql_password" {
  type = string
  description = "The Secret String"
}

variable "project" {
  type = string
  default = "run-app-341001"
  description = "GCP Project Name"
}

variable "zone" {
  type        = string
  default     = "asia-northeast1-a"
  description = "GCP Project Default Zone"
}

