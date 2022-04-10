resource "google_vpc_access_connector" "vpc_connector" {
  name          = "vpc-connector"
  ip_cidr_range = "10.14.0.0/28"
  network       = google_compute_network.private_network.name
}

resource "google_service_account" "run_service_account" {
  project      = "run-app-341001"
  account_id   = "cloud-run-sa"
  display_name = "Cloud Run Service Account"
}

resource "google_secret_manager_secret_iam_member" "run_service_account_rolebinding" {
  project   = "run-app-341001"
  secret_id = google_secret_manager_secret.secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.run_service_account.email}"
}

resource "google_secret_manager_secret" "secret" {
  secret_id = "secret"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-version-data" {
  secret      = google_secret_manager_secret.secret.name
  secret_data = var.cloud_sql_password
}

resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv"
  location = "asia-northeast1"

  template {
    spec {
      containers {
        image = "asia.gcr.io/run-app-341001/goapi:latest"
        env {
          name = "CLOUD_SQL_PASSWORD"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.secret.secret_id
              key  = "latest"
            }
          }
        }
      }
      service_account_name = google_service_account.run_service_account.email
    }

    metadata {
      annotations = {
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.vpc_connector.name
        "run.googleapis.com/vpc-access-egress"    = "private-ranges-only"
      }
    }
  }
  autogenerate_revision_name = true
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
