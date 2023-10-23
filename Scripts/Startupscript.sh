#!/bin/bash

# Step 1: Install Libraries
sudo apt update
sudo apt upgrade -y
# Install GIT
sudo apt install git -y
# Install gcloud sdk for gke 
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin -y
# Install Kubectl
sudo apt-get install kubectl -y

# DOCKER
# Install necessary packages
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add the GPG key for the Docker repository
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock
sudo systemctl restart docker


# Clone the Node.js web app repo
git clone https://github.com/Hendawyy/simple-node-app

cd simple-node-app

# Create a Dockerfile
dfcont=$(cat <<EOL

FROM node:18 AS build

# Create and set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy app code into the container
COPY . .

FROM gcr.io/distroless/nodejs:18

COPY --from=build /app /app

WORKDIR /app

# Expose the port The app runs on
EXPOSE 5000

# Start the Node.js app
CMD ["index.js"]

EOL
)

echo "$dfcont" > Dockerfile


# Build the Docker image
sudo docker build -t node-app:v1 .

# Install and configure Tinyproxy
sudo apt install tinyproxy -y
sudo sh -c "echo 'Allow localhost' >> /etc/tinyproxy/tinyproxy.conf"

# Restart Tinyproxy
sudo service tinyproxy restart


# Step 2: Save the service account key on the VM using wget
wget --header="Metadata-Flavor: Google" -O svacckey.json http://metadata.google.internal/computeMetadata/v1/instance/attributes/sa-1-key

# Step 3: Decrypt the key to JSON format
cat svacckey.json | base64 -d > svacckeyz.json

# Step 4: Activate the service account with the key
gcloud auth activate-service-account --key-file=svacckeyz.json

# Step 5: Configure Docker
gcloud auth configure-docker us-east1-docker.pkg.dev

# Step 6: Login to Docker using the key
cat svacckey.json | docker login -u _json_key_base64 --password-stdin https://us-east1-docker.pkg.dev

# Step 7: Connect to the cluster
gcloud container clusters get-credentials gcp-k8s --zone europe-west1-b --project hendawy-iti-gcp --internal-ip

# Step 8: Enable master global access
gcloud container clusters update gcp-k8s --zone europe-west1-b --enable-master-global-access

# Step 9: Pull mongodb image
docker pull bitnami/mongodb:4.4.4

# Step 10: Tag Docker Image (MONGO)
docker tag bitnami/mongodb:4.4.4 us-east1-docker.pkg.dev/hendawy-iti-gcp/my-images/mongodb:v1

# Step 11: Push Docker Image to Artifact Registry (MONGO)
docker push us-east1-docker.pkg.dev/hendawy-iti-gcp/my-images/mongodb:v1

# Step 12: Tag Docker Image (Node.js)
docker tag node-app:v1 us-east1-docker.pkg.dev/hendawy-iti-gcp/my-images/node-app:v1

# Step 13: Push the docker image (Node.js)
docker push us-east1-docker.pkg.dev/hendawy-iti-gcp/my-images/node-app:v1