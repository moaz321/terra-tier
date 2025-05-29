# ☁️ Three-Tier Architecture on AWS using Terraform

This project provides a **modular and scalable 3-tier architecture on AWS** built entirely with **Terraform**.

It includes:

- **Web Tier**: EC2 instances in public subnets behind a public Application Load Balancer (ALB).
- **App Tier**: EC2 instances running Tomcat in private subnets behind an internal ALB.
- **Database Tier**: RDS MySQL instance in private subnets with multi-AZ and encryption.

---

## 🧰 Features

- Fully modular Terraform structure (VPC, Security Groups, Web/App/DB tiers)
- Public and private subnet isolation with multi-AZ support
- Application Load Balancers (public for Web, internal for App)
- Auto Scaling Groups (ASG) with Launch Templates
- Secure MySQL database (RDS) with parameter group and subnet group
- Simple and customizable deployment via `terraform.tfvars`

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
https://github.com/moaz321/terra-tier.git
cd terra-tier
