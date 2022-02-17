resource "google_project_iam_member" "project" {
  project = "run-app-341001"
  role    = "roles/viewer"
  member  = "user:wakababoxing@gmail.com"
}

resource "google_project_iam_member" "project_cluster" {
  project = "run-app-341001"
  role    = "roles/container.developer"
  member  = "user:wakababoxing@gmail.com"
}

resource "google_service_account" "default" {
  account_id   = "gke-node-service-account-id"
  display_name = "Node Service Account"
}

resource "google_project_iam_member" "gke_node_service_account_rolebinding" {
  project = "run-app-341001"
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.default.email}"
}
