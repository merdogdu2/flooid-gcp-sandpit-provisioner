# Flooid Demo: Ephemeral "Sandpit" Replicas

**Track 3: Ephemeral "Sandpit" Replicas of Product Environments**

This directory contains a demonstration of spinning up full-stack, component-level sandpit replicas of production retail environments on demand, ensuring strict tenant isolation and least-privilege access.

## What's Included

*   `main.tf`: Real Terraform Infrastructure-as-Code (IaC) defining the required resources for a sandpit replica.
    *   **GKE Namespaces** for workload isolation.
    *   **IAM Service Accounts & Workload Identity** mapping for least-privilege access.
    *   **Cloud SQL** database cloned from an anonymized production template.
*   `create-sandpit.sh`: A terminal simulation script designed for live demonstrations to show the developer experience (DX) of provisioning these environments instantly.

## How to Run the Demo

During the meeting, navigate to this directory and run the simulation script:

```bash
cd ~/flooid-demo/sandpit
./create-sandpit.sh --tenant retail-client-a
```

## Key Discussion Points for the Meeting

*   **Speed to Market:** How developers can spin up isolated replicas without waiting on centralized IT/Ops pipelines.
*   **Cost Control:** Sandpits can use cost-effective database tiers and can be tagged for automated TTLs (Time-To-Live) for cleanup (e.g., auto-destroy after 12 hours).
*   **Security:** How Workload Identity bridges the Kubernetes namespace to GCP IAM, strictly preventing cross-tenant data access.
