# Cloud Infrastructure with Terraform & EKS

## Overview
This repository contains the infrastructure setup for a cloud application using Terraform, AWS EKS, and S3 for logging and notification services. It provisions a secure VPC, an EKS cluster for Kubernetes applications

## Key Features
* Provisioning of an AWS VPC with public and private subnets.
* Setup of NAT Gateways for internet access and S3 endpoint for secure access.
* Creation of an EKS Cluster for Kubernetes deployments.
* S3 buckets for log storage and replication.
* Lambda function to process files from S3 (work-in-progress).
* Terraform used for Infrastructure as Code (IaC) and automated provisioning.
* Notifications on Terraform backend changes through AWS SNS (Simple Notification Service).

## Architecture Diagram
![arch](https://github.com/user-attachments/assets/24687309-2b0d-4e99-857a-7de51e42b58c)

## Quick Start
Clone the Repository
```
git clone https://github.com/yourusername/cloud-infrastructure-terraform-eks.git
cd cloud-infrastructure-terraform-eks
```

## Detailed Technical Documentation
For more detailed technical documentation, including infrastructure design, security considerations, and step-by-step breakdowns of the Terraform scripts, please visit the (Technical Documentation)[https://github.com/Darkk-kami/Terra-Eks/wiki]
