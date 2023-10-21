variable "project_id" {
  type        = string
  description = "hendawy-iti-gcp"
}

variable "region" {
  type        = string
  description = "europe-west1"
}


variable "region2" {
  type        = string
  description = "us-east1"
}

variable "zone" {
  type        = string
  description = "europe-west1-b"
}

variable "zone2" {
  type    = string
  default = "us-east1-b"
}

variable "sa-key" {
  type        = string
  description = "~/Documents/Projects/GCP_Project/Project_GCP_iTi/secrets/hendawy-iti-gcp-56dad7e5144e.json"
}
