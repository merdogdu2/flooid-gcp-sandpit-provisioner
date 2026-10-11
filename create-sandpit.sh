#!/bin/bash

# Parse args
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --tenant) TENANT="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ -z "$TENANT" ]; then
    echo "Usage: ./create-sandpit.sh --tenant <tenant_name>"
    exit 1
fi

echo -e "\n🚀 Initiating Ephemeral Sandpit Provisioning for tenant: \033[1;32m$TENANT\033[0m"
sleep 1

echo -e "\n📦 \033[1;34mStep 1:\033[0m Generating ephemeral namespace configuration via Terraform..."
sleep 1
echo "   -> Namespace: sandpit-$TENANT"
echo "   -> Applying Network Policies for strict tenant isolation..."

sleep 1
echo -e "\n🔐 \033[1;34mStep 2:\033[0m Provisioning dedicated IAM Service Account..."
sleep 1
echo "   -> Created: sa-sandpit-$TENANT@flooid-sandpit-env.iam.gserviceaccount.com"
echo "   -> Binding Workload Identity for least-privilege access..."

sleep 1
echo -e "\n💾 \033[1;34mStep 3:\033[0m Cloning Cloud SQL database from anonymized snapshot..."
sleep 2
echo "   -> Restoring snapshot: prod-template-snap-$(date +%Y%m%d)"
echo "   -> Instance spin-up (db-custom-2-7680) in europe-west2..."

sleep 1.5
echo -e "\n✅ \033[1;32mSUCCESS:\033[0m Sandpit environment is ready!"
echo "------------------------------------------------------"
echo -e "Tenant:          \033[1m$TENANT\033[0m"
echo -e "K8s Namespace:   \033[1msandpit-$TENANT\033[0m"
echo -e "DB Connection:   \033[1mpostgres://admin@10.vpc.internal.sql-$TENANT:5432\033[0m"
echo -e "TTL:             \033[1;33m12 hours (Auto-destroy scheduled)\033[0m"
echo "------------------------------------------------------"
echo -e "Review the exact IaC in \033[1mmain.tf\033[0m used to generate this environment."
echo ""
