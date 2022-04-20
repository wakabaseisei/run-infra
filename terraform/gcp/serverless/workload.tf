resource "google_service_account" "github_actions_service_account" {
  project      = var.project
  account_id   = "cloud-workload-identity-sa"
  display_name = "Workload Identity Service Account For Github Actions"
}

resource "google_iam_workload_identity_pool" "workload_pool_for_github_actions" {
  provider = google-beta

  workload_identity_pool_id = "github-actions-pool"
  display_name              = "GitHub Actions Pool"
  disabled                  = false
}

resource "google_iam_workload_identity_pool_provider" "workload_provider_github_actions" {
  provider = google-beta

  workload_identity_pool_id          = google_iam_workload_identity_pool.workload_pool_for_github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "workload-identiry-provider"
  display_name                       = "run"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_binding" "gha_demo" {
  service_account_id = google_service_account.github_actions_service_account.name
  role               = "roles/iam.workloadIdentityUser"
// TODO: 
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.workload_pool_for_github_actions.name}/attribute.repository/[your_github_name]/[your_repository_name]",
  ]
}