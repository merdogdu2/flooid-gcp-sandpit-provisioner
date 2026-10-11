terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

variable "tenant_name" {
  description = "Name of the tenant for the sandpit"
  type        = string
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "flooid-sandpit-env"
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "europe-west2" # London
}

# 1. Ephemeral GKE Namespace
resource "kubernetes_namespace" "tenant_sandpit" {
  metadata {
    name = "sandpit-${var.tenant_name}"
    labels = {
      tenant      = var.tenant_name
      environment = "sandpit"
      ephemeral   = "true"
    }
  }
}

# 2. Strict Tenant Isolation: Dedicated Service Account
resource "google_service_account" "tenant_sa" {
  account_id   = "sa-sandpit-${var.tenant_name}"
  display_name = "Sandpit Service Account for ${var.tenant_name}"
}

# 3. Workload Identity Binding (Mapping GKE namespace to GCP Identity)
resource "google_service_account_iam_binding" "workload_identity" {
  service_account_id = google_service_account.tenant_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[sandpit-${var.tenant_name}/default]"
  ]
}

# 4. Cloned Cloud SQL Instance (simulating snapshot restore)
resource "google_sql_database_instance" "tenant_db_clone" {
  name             = "sql-sandpit-${var.tenant_name}"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = "db-custom-2-7680" # Cost-effective sandpit tier
    
    # In a real Flooid scenario, this clone block points to an anonymized nightly snapshot
    # clone {
    #   source_instance_name = "projects/${var.project_id}/instances/prod-db-template"
    # }
  }
}
