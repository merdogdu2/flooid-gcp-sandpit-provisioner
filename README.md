# 🏗️ Flooid Demo: Ephemeral "Sandpit" Replicas

![Google Cloud](https://img.shields.io/badge/GoogleCloud-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)

**Track 3: Ephemeral "Sandpit" Replicas of Product Environments**

This directory contains a demonstration of spinning up full-stack, component-level sandpit replicas of production retail environments on demand, ensuring strict tenant isolation and least-privilege access.

---

## 🏛️ Architecture Flow

The sandpit provisioning automates the creation of a secure, isolated environment cloned directly from anonymized production templates.

```mermaid
graph TD
    A[Developer / CI Pipeline] -->|Runs ./create-sandpit.sh| B(Provisioning Wrapper)
    B -->|Executes IaC| C{Terraform Module}
    
    subgraph GCP Environment [GCP Project: flooid-sandpit-env]
        C -->|1. Creates| D[GKE Namespace <br/> <i>sandpit-tenant-a</i>]
        C -->|2. Provisions| E[IAM Service Account <br/> <i>Least Privilege</i>]
        C -->|3. Clones| F[(Cloud SQL Postgres <br/> <i>Anonymized</i>)]
    end
    
    E -.->|Workload Identity Binding| D
    F -.->|Nightly Snapshot Clone| F
    
    style A fill:#4285F4,stroke:#333,stroke-width:2px,color:#fff
    style C fill:#5835CC,stroke:#333,stroke-width:2px,color:#fff
    style D fill:#326ce5,stroke:#333,stroke-width:1px,color:#fff
    style E fill:#34A853,stroke:#333,stroke-width:1px,color:#fff
    style F fill:#FBBC05,stroke:#333,stroke-width:1px,color:#000
```

---

## 📦 What's Included

*   **`main.tf`**: Real Terraform Infrastructure-as-Code (IaC) defining the required resources for a sandpit replica.
    *   **GKE Namespaces:** For workload isolation and network policy boundaries.
    *   **IAM Service Accounts & Workload Identity:** Mapping GKE service accounts to GCP IAM for least-privilege access.
    *   **Cloud SQL Database:** Configured to clone from an anonymized production snapshot template.
*   **`create-sandpit.sh`**: A terminal simulation script designed for live demonstrations to show the developer experience (DX) of provisioning on-demand sandpits instantly.
*   **`migrate-tenant.sh`**: A simulation tool demonstrating how to codify an existing customer's legacy environment (e.g., Primark on N2 instances), translate the Infrastructure-as-Code via an agent, and re-deploy it into a sandbox using modernized instance families (e.g., C4) for Q4 peak testing.

---

## 🚀 How to Run the Demos

### Demo 1: On-Demand Component Replicas
During the meeting, run the simulation script to spin up an ephemeral environment:
```bash
cd ~/flooid-demo/sandpit
./create-sandpit.sh --tenant retail-client-a
```

### Demo 2: Codifying & Upgrading Legacy Environments (N2 -> C4)
To demonstrate scanning an existing project and translating its IaC to modern C4 instances in a sandbox:
```bash
cd ~/flooid-demo/sandpit
./migrate-tenant.sh --customer primark --source-project primark-prod-1a2b --target-family c4
```
*(This script will generate a new Terraform file in the `./exports/` directory showing the upgraded `machine_type` configurations).*

---

## 💡 Key Discussion Points for the Meeting

1.  **Speed to Market:** Developers can spin up isolated replicas without waiting on centralized IT/Ops pipelines or ticketing systems.
2.  **Cost Control:** Sandpits use cost-effective database tiers and can be tagged for automated TTLs (Time-To-Live) for cleanup (e.g., auto-destroy after 12 hours to prevent resource bloat).
3.  **Security & Strict Isolation:** Showcases how Workload Identity bridges the Kubernetes namespace directly to GCP IAM, strictly preventing cross-tenant data access or lateral movement.
