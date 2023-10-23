# Infrastructure as a Code (IAC) in GCP ☁️

This project showcases the power of Infrastructure as Code (IAC) through Terraform, enabling the creation of GCP ☁️ Infrastructure:

## The project encompasses the following components:

- Terraform Infrastructure: Develop and utilize custom Terraform modules to construct the necessary infrastructure on Google Cloud Platform, including IAM setup, network configuration (VPC, subnets, firewall rules, NAT), compute resources (private VM, GKE standard cluster spanning three zones), and storage through the Artifact Registry.

- MongoDB Deployment: Implement a MongoDB replica set across three distinct zones, ensuring high availability and data redundancy.

- Containerization with Docker: Dockerize the Node.js web application, enabling it to seamlessly connect with the three MongoDB replicas.

- Exposure via Ingress and Load Balancer: Expose the web application using an ingress controller and load balancer, ensuring accessibility and distribution of traffic.

## Key Considerations:

- Restricted Internet Access: Only the management VM (private) will have access to the internet through NAT, enhancing security and control.

- Isolated GKE Cluster: The GKE cluster (private) will not have external internet access, emphasizing network security.

- Artifact Management: The management VM is designated for cluster management and image building/pushing to the Artifact Registry, ensuring centralized artifact storage.

- Security Best Practices: Employ predefined roles and avoid the use of default service accounts, promoting best security practices.

- Minimal Open Ports: Reduce open ports and permissions to enhance security and minimize potential vulnerabilities.

![Requirements](./Req/Requirements.png)

## 🚀 Getting Started

### Prerequisites  🛠️

Before you begin, ensure you have the following installed:

- Terraform 🏗️
- gcloud ☁️
- Docker  🐋
- Kubectl

