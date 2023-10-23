# Infrastructure as a Code (IAC) in GCP ☁️

This project showcases the power of Infrastructure as Code (IAC) through Terraform, enabling the creation of GCP ☁️ Infrastructure:

## The project encompasses the following components:

- Terraform Infrastructure: Develop and utilize custom Terraform modules to construct the necessary infrastructure on Google Cloud Platform, including IAM setup, network configuration (VPC, subnets, firewall rules, NAT), compute resources (private VM, GKE standard cluster spanning three zones), and storage through the Artifact Registry.

- MongoDB Deployment: Implement a MongoDB replica set across three distinct zones, ensuring high availability and data redundancy.

- Containerization with Docker: Dockerize the Node.js web application, enabling it to seamlessly connect with the three MongoDB replicas.

- Exposure via Ingress and Load Balancer: Expose the web application using an ingress controller and load balancer, ensuring accessibility and distribution of traffic.

![Requirements](./Req/Requirements.png)

## 🚀 Getting Started

### Prerequisites  🛠️

Before you begin, ensure you have the following installed:

- Terraform 🏗️
- Google Cloud SDK ☁️
- Docker  🐋
- Kubectl ☸

### Install The Google Cloud SDK ☁️.

1. Open a terminal window.
2. Run the following command:
   
  ```
  sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
  ```
3. Then you will need to configure your account and select your project, for this you will use the following command:

  ```
  gcloud auth login
  ```
4. you will be prompted to enter the project id.
> [!NOTE]
> you can get the project id by going to the GCP console and in the dashboard you will find the project id
> The chosen project will be the default project for all the gcloud commands till changed

---- 🌟 ----

### Clone this repository to your local environment to start setting up the infrastructure.

Run the following command:
  ```
  git clone https://github.com/Hendawyy/Project_GCP_iTi.git
  cd Project_GCP_iTi
  ```

---- 🌟 ----

### Now We Can Get to The Terraform

To be able to use the GCP from the terraform you will have to
1. Create a service account for this we can do it using the GCP console or the gcloud commands
   GCP console:
    1. Navigate to the IAM
    2. Then find Service Accounts
    3. Create A service account
    4. Give this account the editor role
    5. inside this service account find keys
    6. Add Key
    7. Choose JSON format
    8. After adding the key it will be downloaded automatically
    9. Copy this key to your project directory
    10. Create a directory called "Secrets"
    11. Copy your key to this directory
   gcloud Commands
    1. First we create the Svc Account & Add The role
       ```
       gcloud iam service-accounts create SERVICE_ACCOUNT_NAME --display-name "DISPLAY_NAME"
       gcloud projects add-iam-policy-binding YOUR_PROJECT_ID --member=serviceAccount:SERVICE_ACCOUNT_EMAIL --role=roles/editor
       ```
    2. Then We Create the Key
        ```
        gcloud iam service-accounts keys create KEY_FILE.json --iam-account SERVICE_ACCOUNT_EMAIL
        ```
    3. Copy this key to your project directory
    4. Create a directory called "Secrets"
    5. Copy your key to this directory

2. Then we add this key path inside our terraform variables and we can use it freely inside our terraform configurations
3. Now You Can run the Terraform configuration files
4. The terraform runs a shell script inside the Private VM instance 

   ```
    cd Terraform\
    terraform init
    terraform plan
    terrafrom apply
    ```

> [!NOTE]
> The ``` terraform apply ``` command might take up to 15 mins to finish executing
> You can check the output in the Screenshots directory

---- 🌟 ----

### Startup Script

1. The Startup script can be found in ```Scripts/Startupscript.sh``` and
2. The script automates the deployment process of a Node.js web application to Google Cloud Platform (GCP) using Docker and Kubernetes.
3. The script simplifies various tasks, including setting up the development environment, building Docker images, and deploying them to GCP's Artifact Registry.
4. The script Installs Dependencies: The script installs essential libraries, Git, Google Cloud SDK for GKE, Kubectl, and Docker.
5. The script Clones a Node.js web app
6. The script creates a Dockerfile for the Node.js app, builds a Docker image, and exposes it on port 5000.
7. The script installs & Confgures Tinyproxy which allows us to acces the Private VM instance from the local machine.
8. GCP Authentication: The script fetches a service account key, decrypts it, activates the service account, and configures Docker for GCP.
9. Cluster Connection: It connects to the GCP Kubernetes cluster.
10. The script pulls a MongoDB image, tags it, and pushes it to GCP Artifact Registry. It does the same for the Node.js app.

---- 🌟 ----

### Post Terraform Apply

1. After Applying the terraform the user will want to acces the Private VM instance through Identity-Aware Proxy (IAP), you can do thet using the following command:
   ```
   gcloud compute ssh private-vm-instance --project=hendawy-iti-gcp --zone=us-east1-b --tunnel-through-iap
   ```
2. After accessing the machine you can check the Startup script Progress by seeing the log file, you can do that by executing the following command:
   ```
   cat /var/log/syslog
   ```
3. If all is good and the script finished running you can exit the machine by running the ```exit``` command
   
> [!NOTE]
> You can also check if the script ran successfully or not by going to the artifact registrey on the GCP console
> you should find a repository called my-images inside it you will find 2 docker images node-app & mongoDB
> you can see what it will look like in the Screenshots inside the ```Screenshtos``` directory

---- 🌟 ----

### 🌐  Remotely access the GKE Cluster from the local machine
1. Using the Tinyproxy we can deploy a proxy daemon in the host to forward traffic to the cluster control plane.
2. We must set up the remote client with cluster credentials and specify the proxy.
3. To do that we need to get the Credentials of the cluster through the following command
   ```
   gcloud container clusters get-credentials gcp-k8s --zone europe-west1-b --project hendawy-iti-gcp --internal-ip
   ```
4. Connect to the cluster from the remote local private instance using IAP and Deploy The Web Application
   ```
   gcloud compute ssh private-vm-instance \
    --tunnel-through-iap \
    --project=hendawy-iti-gcp \
    --zone=us-east1-b \
    --ssh-flag="-4 -L8888:localhost:8888 -N -q -f" 2>/dev/null
   ```
5. Specify the proxy
   ```
   export HTTPS_PROXY=localhost:8888
   ```
6. Then Show GKE Nodes
   ```
   kubectl get nodes
   ```
> [!NOTE]
> There is a shell script called ```local_script.sh``` inside the ```Scripts``` directory that does all the steps in thus part
> and it also applies The Kubernetes files for the MongoDB (Backend Configuration)
> and the files for the Nodejs App (Frontend Configuration) as well you can run this script by executing the following commands
> ```
> cd Project_GCP_iTi/Scripts/
> source local_script.sh 
> ```






## Questions or Need Help?

If you have any questions, suggestions, or need assistance, please don't hesitate to Contact Me [Seif Hendawy](mailto:seifhendawy1@gmail.com). 😉

