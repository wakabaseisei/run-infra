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