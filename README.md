# 🚀 Terraform: OCI OKE with VCN IP Native (Private Cluster)

This Terraform configuration deploys a **private Oracle Kubernetes Engine (OKE)** cluster on OCI using **VCN IP Native** networking.

## ✅ What It Deploys

- VCN with regional private subnets  
- NAT Gateway and Service Gateway  
- Route Tables and Security Lists  
- OKE Cluster (VCN IP Native, no public IPs)  
- Node Pool with custom image & shape  

## 📦 Usage

```bash
terraform init
terraform plan
terraform apply

Note: Ensure to update compartment_id, and tenancy and user credentials before applyting terraform
