# 🖥️ Azure Virtual Desktop — Enterprise Infrastructure with Terraform

> Production-ready AVD infrastructure deployed with a single command.
> Domain joined · FSLogix profiles · Auto scaling · Full monitoring.

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Windows](https://img.shields.io/badge/Windows_11-0078D4?style=for-the-badge&logo=windows&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

---

## 📸 Infrastructure Overview

| Resource Group | Host Pool |
|---|---|
| ![Resource Group](Screenshot%20Images/Resource%20Group.png) | ![Host Pool](Screenshot%20Images/Host%20pools.png) |

| Session Hosts | Azure Compute Gallery |
|---|---|
| ![Session Hosts](Screenshot%20Images/Session%20hosts.png) | ![Gallery](Screenshot%20Images/Azure%20compute%20galleries.png) |

| Auto Scaling Plan | Azure Monitor |
|---|---|
| ![Scaling](Screenshot%20Images/avd-scaling-plan.png) | ![Monitor](Screenshot%20Images/Monitor.png) |

| FSLogix Profiles | Domain Controller |
|---|---|
| ![FSLogix](Screenshot%20Images/fslogix-profile.png) | ![DC](Screenshot%20Images/Domain%20Controller.png) |

---

## 🏗️ Architecture

┌─────────────────────────────────────────────────────┐
│                  AVD-image-Lab                      │
│                  Resource Group                     │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │         Vnet01  10.0.0.0/16                 │   │
│  │  subnet0 (AVD) │ subnet1 (DC)               │   │
│  │  DNS → 10.0.1.4                             │   │
│  └─────────────────────────────────────────────┘   │
│                                                     │
│  ┌──────────────┐    ┌──────────────────────────┐  │
│  │  avd-dc-01   │    │    AVD Control Plane      │  │
│  │  WS 2022     │    │  avd-lab-hostpool         │  │
│  │  avdlab.local│    │  avd-lab-workspace        │  │
│  │  10.0.1.4    │    │  avd-lab-appgroup         │  │
│  └──────────────┘    └──────────────────────────┘  │
│                                                     │
│  ┌──────────────────────────────────────────────┐  │
│  │           Session Hosts                      │  │
│  │  avd-sh-0  │  avd-sh-1                       │  │
│  │  Win11 24H2 Multi-session                    │  │
│  │  Domain Joined · FSLogix Enabled             │  │
│  └──────────────────────────────────────────────┘  │
│                                                     │
│  ┌──────────────┐    ┌──────────────────────────┐  │
│  │   FSLogix    │    │      Monitoring           │  │
│  │  Azure Files │    │  Log Analytics            │  │
│  │  SMB Share   │    │  6 Alert Rules            │  │
│  │  100GB quota │    │  Email Notifications      │  │
│  └──────────────┘    └──────────────────────────┘  │
│                                                     │
│  ┌──────────────────────────────────────────────┐  │
│  │           Auto Scaling Plan                  │  │
│  │  Weekdays: 06:00 → 20:00  │  Weekend: Min    │  │
│  │  67% cost saving                             │  │
│  └──────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘

---

## ✅ What's Deployed

| Component | Resource | Details |
|---|---|---|
| 🌐 Network | Vnet01 | 10.0.0.0/16 · 2 subnets |
| 🏢 Domain Controller | avd-dc-01 | Windows Server 2022 · avdlab.local |
| 🖥️ Host Pool | avd-lab-hostpool | Pooled · BreadthFirst |
| 💼 Workspace | avd-lab-workspace | 1 App Group |
| 🖥️ Session Hosts | avd-sh-0, avd-sh-1 | Win11 24H2 · Domain Joined |
| 👤 Profiles | FSLogix | Azure Files SMB · 100GB |
| 📊 Monitoring | Log Analytics | 6 Alert Rules · Email |
| ⚖️ Scaling | avd-scaling-plan | Weekday + Weekend schedules |
| 🗄️ Storage | avdlabscripts001 | Scripts + Profiles |
| 🖼️ Gallery | avdLabGallery | Win11 multisession images |

---

## 📁 Module Structure

modules/
├── avd/
│   ├── hostpool/          # AVD Host Pool + Workspace + App Group
│   ├── build-vm/          # Golden image build VM
│   ├── domain-controller/ # Windows Server 2022 DC
│   ├── domain-join/       # Auto domain join session hosts
│   ├── session-hosts/     # AVD Session Hosts from gallery
│   ├── app-install/       # App install via Custom Script Extension
│   ├── sysprep/           # Automated sysprep
│   ├── image-capture/     # Capture golden image to gallery
│   ├── image-gallery/     # Azure Compute Gallery
│   ├── scaling-plan/      # Auto scaling weekday/weekend
│   └── fslogix/           # FSLogix profile management
├── monitoring/            # Log Analytics + 6 Alert Rules
├── network/vnet/          # VNet + Subnets + DNS
├── storage/               # Storage Account + File Share
└── resourcegroup/         # Resource Group

---

## 🌍 Multi-Environment Support

```bash
# Non-Prod — 2 hosts · Standard_D2s_v3 · centralus
terraform plan -var-file="environments/non-prod/terraform.tfvars"

# Prod — 10 hosts · Standard_D4s_v5 · centralus  
terraform plan -var-file="environments/prod/terraform.tfvars"

# DR — 2 hosts · eastus · failover ready
terraform plan -var-file="environments/dr/terraform.tfvars"
```

| Environment | Location | Hosts | VM Size | Cost |
|---|---|---|---|---|
| Non-Prod | centralus | 2 | Standard_D2s_v3 | ~$150/mo |
| Prod | centralus | 10 | Standard_D4s_v5 | ~$800/mo |
| DR | eastus | 2 | Standard_D2s_v3 | ~$300/mo |

---

## ⚡ Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/Shabeer1024/azure-avd-infra-automation

# 2. Navigate to project
cd azure-avd-infra-automation

# 3. Create your variables file
cp terraform.tfvars.example terraform.tfvars
# Fill in your values

# 4. Initialize Terraform
terraform init

# 5. Plan
terraform plan -out main.tfplan

# 6. Deploy
terraform apply main.tfplan
```

---

## 📋 Prerequisites

- Azure subscription
- Terraform >= 1.0
- Azure CLI installed and logged in
- PowerShell

---

## ⚙️ Auto Scaling Schedule

Weekdays:
06:00 → Ramp up (VMs start)
09:00 → Peak hours (all VMs running)
18:00 → Ramp down (drain sessions)
20:00 → Off peak (VMs deallocate)
Weekend:
Minimum hosts only
Cost saving: ~67% vs always-on ✅