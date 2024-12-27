provider "google" {
  project = "playground-s-11-2a50d57f"
  region  = "us-central1"
}
resource "google_container_cluster" "primary" {
  name     = "terminal-cluster"
  location = "us-central1"
  
  initial_node_count = 1
  
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  node_config {
    machine_type = "e2-medium"
    
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    service_account = google_service_account.gke_sa.email
  }
}

resource "google_service_account" "gke_sa" {
  account_id   = "gke-service-account"
  display_name = "GKE Service Account"
}

resource "google_container_registry" "registry" {
  location = "US"
}
resource "google_project_iam_binding" "gke_sa_binding" {
 project = var.project_id
 role    = "roles/container.developer"
 members = ["serviceAccount:${google_service_account.gke_sa.email}"]
}

resource "google_service_account_iam_binding" "workload_identity_binding" {
 service_account_id = google_service_account.gke_sa.name
 role               = "roles/iam.workloadIdentityUser"
 members = [
   "serviceAccount:${var.project_id}.svc.id.goog[default/default]"
 ]
}

resource "google_project_iam_binding" "registry_binding" {
 project = var.project_id
 role    = "roles/storage.objectViewer"
 members = ["serviceAccount:${google_service_account.gke_sa.email}"]
}

variable "project_id" {
 type = string
}
