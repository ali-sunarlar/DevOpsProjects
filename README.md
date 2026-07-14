# DevOps & Infrastructure Engineering Repository

This repository is a comprehensive collection of production-grade automation playbooks, Infrastructure as Code (IaC) templates, containerization labs, and enterprise security scripts designed for modern cloud and hybrid architectures.

## 📂 Repository Structure

- **`Ansible/`**: Declarative playbooks for OS hardening, application deployments, user management, and configuration baselining.
- **`Azure_Labs/`**: Enterprise Cloud Architecture labs utilizing Terraform.
  - *`App_Service_CosmosDB_KeyVault`*: Decoupled PaaS architecture secured with Private Endpoints and VNet Integration.
  - *`Microservices_ACA`*: Serverless microservice apps hosted on Azure Container Apps (ACA).
  - *`EventDriven_Serverless`*: Decoupled queue processing with Azure Service Bus and Consumption-based Functions.
- **`Docker/` & `ContainerLab/`**: Multi-stage Dockerfiles and compose setups for modern web stacks (.NET, Node.js, Spring, Angular).
- **`Kubernetes/`**: Advanced AKS blueprints featuring ArgoCD GitOps, Canary deployments (Argo Rollouts), Network Policies, and Velero backup strategies.
- **`GoogleCloud/`**: Challenging labs focusing on GCP VPCs, Compute Engine, Storage, and ML API integration scripts.
- **`Infrastructure/`**: Enterprise-grade SIEM pipelines (Fluent-Bit & Auditd) and secure hybrid Active Directory integration tools.
- **`Windows/`**: PowerShell automation pipelines and rapid vulnerability scanning scripts (e.g., CVE audits).

## 🛠️ Tech Stack & Tooling

- **IaC:** Terraform
- **Configuration Management:** Ansible
- **Containerization & Orchestration:** Docker, Kubernetes (AKS)
- **CI/CD & GitOps:** ArgoCD
- **Cloud Providers:** Microsoft Azure, Google Cloud Platform (GCP)
- **Scripting:** PowerShell (Core & Windows), Bash, Python

## 🚀 Purpose

The primary goal of this repository is to showcase automation best practices, Zero-Trust network topologies, event-driven serverless patterns, and end-to-end cloud infrastructure lifecycle management.