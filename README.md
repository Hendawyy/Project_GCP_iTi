# Infrastructure as Code (IAC) in Google Cloud Platform (GCP) ☁️

This project showcases the power of Infrastructure as Code (IAC) through Terraform, enabling the creation of GCP ☁️ Infrastructure:

## Project Components  🛠️

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
3. Configure your GCP account and select your project by running:

  ```
  gcloud auth login
  ```
4. You will be prompted to enter the project ID.
> [!NOTE]
> you can get the project id by going to the GCP console and in the dashboard you will find the project id
> The chosen project will be the default project for all the gcloud commands till changed

---- 🌟 ----

### Clone this repository to your local environment to start setting up the infrastructure.

To set up the infrastructure, clone this repository to your local environment:
  ```
  git clone https://github.com/Hendawyy/Project_GCP_iTi.git
  cd Project_GCP_iTi
  ```

---- 🌟 ----

### Now We Can Get to The Terraform 🏗️

To utilize GCP within Terraform, follow these steps:
1. Create a service account. You can do this through the GCP console or using gcloud commands:
   GCP console:
    1.1. Navigate to IAM.
    1.2. Find Service Accounts.
    1.3. Create a service account.
    1.4. Grant the editor role to this account.
    1.5. Inside this service account, find keys.
    1.6. Add a key and choose the JSON format.
    1.7. After adding the key, it will be downloaded automatically.
    1.8. Copy this key to your project directory.
    1.9. Create a directory called "secrets."
    1.10. Copy your key to this directory.
   gcloud Commands
    1. Create the service account and grant the editor role:
       ```
       gcloud iam service-accounts create SERVICE_ACCOUNT_NAME --display-name "DISPLAY_NAME"
       gcloud projects add-iam-policy-binding YOUR_PROJECT_ID --member=serviceAccount:SERVICE_ACCOUNT_EMAIL --role=roles/editor
       ```
    2. Then We Create the Key:
        ```
        gcloud iam service-accounts keys create KEY_FILE.json --iam-account SERVICE_ACCOUNT_EMAIL
        ```
    3. Copy this key to your project directory.
    4. Create a directory called "secrets."
    5. Copy your key to this directory.

2. Add the key path to your Terraform variables, allowing you to use it within your Terraform configurations.
3. Run the Terraform configuration files with the following commands:

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

### Startup Script 🖥️

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

1. After applying the Terraform configuration, you'll want to access the private VM instance through Identity-Aware Proxy (IAP). Use the following command:
   ```
   gcloud compute ssh private-vm-instance --project=hendawy-iti-gcp --zone=us-east1-b --tunnel-through-iap
   ```
2. Once you've accessed the machine, check the progress of the startup script by viewing the log file:
   ```
   cat /var/log/syslog
   ```
3. If the script ran successfully, you can exit the machine by running the ```exit``` command.
   
> [!NOTE]
> You can also check if the script ran successfully by going to the Artifact Registry in the GCP console.
> You should find a repository called my-images, which contains two Docker images: node-app and mongoDB.
> You can see what it looks like in the Screenshots directory.

---- 🌟 ----

### 🌐  Remotely access the GKE Cluster from the local machine

To remotely access the GKE cluster from your local machine, follow these steps:
1. Deploy a proxy daemon using Tinyproxy on your host to forward traffic to the cluster control plane.
2. Set up the remote client with cluster credentials and specify the proxy.
3. Obtain the cluster credentials using the following command:
   ```
   gcloud container clusters get-credentials gcp-k8s --zone europe-west1-b --project hendawy-iti-gcp --internal-ip
   ```
4. Connect to the cluster from the remote local private instance using IAP and deploy the web application:
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
> There is a shell script called local_script.sh in the Scripts directory that automates these steps
> and applies the Kubernetes files for MongoDB (Backend Configuration) and the Node.js App (Frontend Configuration).
> You may need to change the absolute path of your project inside the local_script.sh file on line 22.
> You can run this script by executing the following commands:
> ```
> cd ../Scripts/
> source local_script.sh 
> ```
7. After running The Script You should run the following Command to get the The IP Address where the Web application is deployed:
   ```
   kubectl get svc -n node
   ```
8. Copy the External-IP and paste it into your browser to access the web application. This app displays the number of visits, which increases every time you reload the page.
9. this app has ```visists:number of visits``` every time you reload the ```number of visits``` will increase
10. since in Kubernetes (K8s), "stateful" means  that each pod in a stateful application has persistent storage to maintain its state. If the database fails for any reason, you can still access the data.
11. You can check this by destroying mongodb-0 and then reloading the browser. The ```number of visits``` will remain unchanged and increase from the last visit.
   ```
   curl <EXTERNAL_IP>
   delete pods mongodb-0-n mongo
   curl <EXTERNAL_IP>
   ```
> [!NOTE]
> There is a shell script called Check_Stateful.sh in the Scripts directory that automates these steps.
> You can run this script by executing the following commands:
> ```
> source Check_Stateful.sh EXTERNAl_IP
> ```
> replace the ```EXTERNAl_IP``` with the ```EXTERNAl_IP``` from the  ```kubectl get svc -n node``` command 

---- 🌟 ----

### 🧹 Clean Up

To clean up and delete all resources:
```
# Delete all pods by deleting namespaces
kubectl delete ns mongo node

# Stop listening on the remote client
netstat -lnpt | grep 8888 | awk '{print $7}' | grep -o '[0-9]\+' | sort -u | xargs sudo kill

# Change directory to Terraform
cd ../terraform

# Destroy all resources
terraform destroy
```

During the destruction, you'll need to delete the disks used by the databases from the Google Cloud Console. Go to Compute Engine, select Disks, and press Delete for all disks. 

---- 🌟 ----

## Questions or Need Help?

If you have any questions, suggestions, or need assistance, please don't hesitate to Contact Me [Seif Hendawy](mailto:seifhendawy1@gmail.com). 😉

