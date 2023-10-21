resource "google_service_account" "sa_1" {
  account_id   = "svcaccmngmt"
  display_name = "GCP-iTi-Management-SA"
}

resource "google_project_iam_member" "sa_1_role" {
  project = var.project_id
  count   = length(var.rolezzz)
  role    = var.rolezzz[count.index]
  member  = "serviceAccount:${google_service_account.sa_1.email}"
}

resource "google_service_account" "K8S" {
  account_id   = "kubernetes"
  display_name = "GCP-iTi-Sa2"
}


