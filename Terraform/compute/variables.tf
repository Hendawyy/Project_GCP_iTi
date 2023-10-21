variable "project_id" {
  type    = string
  default = "hendawy-iti-gcp"
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "zone" {
  type    = string
  default = "europe-west1-b"
}

variable "sa-key" {
  type    = string
  default = "~/Documents/Projects/GCP_Project/Project_GCP_iTi/secrets/hendawy-iti-gcp-56dad7e5144e.json"
}

variable "network_name" {
  type = string
}

variable "google_compute_subnet" {
}

variable "google_compute_subnet2" {
}

variable "sa_1_email" {
}

variable "K8S_email" {
}


variable "region2" {
  type    = string
  default = "us-east1"
}

variable "zone2" {
  type    = string
  default = "us-east1-b"
}
