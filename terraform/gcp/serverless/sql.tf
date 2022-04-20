resource "google_compute_network" "private_network" {
  name = "private-networks"
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "instance" {
  name       = "mysql-instance"
  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
    }
  }
  region           = "asia-northeast1"
  database_version = "MYSQL_5_7"

  deletion_protection = "true"
}

resource "google_sql_user" "users" {
  name     = "go_user"
  instance = google_sql_database_instance.instance.name
  password = var.cloud_sql_password
}

resource "google_sql_database" "database" {
  name     = "go_database"
  instance = google_sql_database_instance.instance.name
}