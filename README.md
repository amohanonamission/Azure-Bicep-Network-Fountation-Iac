# Azure Enterprise Hub-Spoke Network Foundation (IAC)

### Objective
This repository implements a **Secure Hub-Spoke Network Architecture** in Azure using Bicep. It establishes a centralized management **"Hub" and a protected "Spoke"** for application workloads, following the Microsoft Cloud Adoption Framework (CAF) for enterprise-grade security.

### Key Infrastructure Components:
* **Infrastructure as Code (IaC):** Subscription-level deployment using modular Bicep templates.
* **VNET & Subnet Isolation:** Separated `frontend` and `isolated-db` tiers to minimize lateral movement.
* **VNET Peering:** Implemented high-performance, low-latency private peering between the Hub and Spoke for secure cross-network communication.
* **Hub-Spoke Topology:** Centralized management via a Hub VNET to isolate administrative traffic from production workloads.
* **Secure Management:** Fully managed RDP/SSH access via Azure Bastion, eliminating the need for Public IPs on internal Virtual Machines.
* **Micro-Segmentation:** Granular traffic control using Network Security Groups (NSGs) to enforce a Zero-Trust posture.
* **Scalability:** Designed to support multiple spokes (Departments/Apps) while maintaining a centralized security perimeter.
* **Zero-Trust Networking:** Strict "Default-Deny" Network Security Group (NSG) policy.

### Technical Specifications:


| Component | Detail | Security Value |
| -------- | -------- | -------- |
| Hub VNET | 10.1.0.0/16 | Centralized Management Plane |
| Azure Bastion | /26 Subnet | Protects against port-scanning & brute-force attacks |
| Spoke VNET | 10.0.0.0/16 | Isolated Workload Zone |
| NSG Baseline | Default-Deny | Blocks all lateral movement by default |


### How to Deploy:

```bash
az login
az deployment sub create \
  --location centralindia \
  --template-file main.bicep \
  --parameters parameters.json

```

### Security & Compliance Audit:

* **Public IP Reduction:** Public IPs are restricted to the Bastion service only; no workload resources are exposed to the public internet.
* **Operational Integrity:** Implemented CanNotDelete Resource Locks on core infrastructure (Hub VNET) to prevent accidental deletion and ensure high availability of the management plane.
* **Management Plane Isolation:** Management traffic is physically and logically separated from the data plane.
* **Encryption in Transit:** VNET Peering traffic stays on the Microsoft backbone and is not exposed to the public internet.
* **Traffic Control:** Inbound traffic is strictly restricted to **TCP Port 443** (HTTPS) via NSG rule `AllowHTTPSInbound`.
* **Egress Hardening:** Enforced an explicit DenyAllOutbound NSG policy. Only authorized traffic (HTTPS/443) is permitted to exit the network, mitigating the risk of data exfiltration and Command & Control (C2) callbacks.
* **Micro-segmentation:** Verified that `snet-db-001` has no direct internet route and is logically separated from the `snet-web-001`.

## Visual Documentation

### 1. Bicep Architecture Diagram (VS Code & Azure)

![Architecture Diagram](images/vscode-visualizer.png)
![Azure Portal Visualizer](images/azure-resource-overview.png)

### 2. Deployed Resources (Azure Portal)
![Azure Portal Resources](images/resource-review.png)
![Deployment Status](images/network-status.png)

### 3. Security Hardening (NSG Rules)
![NSG Security Rules](images/nsg-rules.png)

### 4. Resource Lock 
![Resource Lock](images/resource-lock.png)

