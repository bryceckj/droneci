# ssh to Docker-Build EC2 instance
ssh <IP>

# In AWS, enable SG inbound rules port 80 (HTTP) and port 3000

# Install Drone CLI
curl -L https://github.com/drone/drone-cli/releases/latest/download/drone_linux_amd64.tar.gz | tar zx
sudo install -t /usr/local/bin drone

# In Github, set up OAuth for Drone
# Log into github.com
# Click on your user menu (top right corner), select Settings
# On the left side menu, select Developer Settings
# Select OAuth Apps
# Create New OAuth App:
# Application Name: DroneCI
# Homepage URL: <http://IP-address> 
# Callback URL: <http://IP-address/login> 
# Note down your Client ID and Client Secret

# In Github, set up Personal Access Token for Git Clone
# Log into github.com
# Click on your user menu (top right corner), select Settings
# On the left side menu, select Developer Settings
# Select OAuth Apps
# Personal Access Tokens:
# Generate new token
# Take note of token number


# Set up Drone Server in Docker

docker pull drone/drone:1
openssl rand -hex 16

DRONE_GITHUB_CLIENT_ID=
DRONE_GITHUB_CLIENT_SECRET=
DRONE_RPC_SECRET=
DRONE_SERVER_HOST=<IP>:80
DRONE_SERVER_PROTO=http
DRONE_DOCKER_CONFIG=/root/.docker/config.json

docker run \
--volume=/var/lib/drone:/data \
--env=DRONE_GITHUB_CLIENT_ID=${DRONE_GITHUB_CLIENT_ID} \
--env=DRONE_GITHUB_CLIENT_SECRET=${DRONE_GITHUB_CLIENT_SECRET} \
--env=DRONE_RPC_SECRET=${DRONE_RPC_SECRET} \
--env=DRONE_SERVER_HOST=${DRONE_SERVER_HOST} \
--env=DRONE_SERVER_PROTO=${DRONE_SERVER_PROTO} \
--env=DRONE_AGENTS_ENABLED=true \
--env=DRONE_GITHUB_SERVER=https://github.com \
--env=DRONE_USER_CREATE=username:bryceckj,admin:true \
--env=PATH=$PATH:/usr/sbin \
--privileged \
--publish=80:80 \
--publish=443:443 \
--restart=always \
--detach=true \
--name=drone \
--network=host \
drone/drone:1


# Drone Runner in Docker

docker pull drone/drone-runner-docker:1

DRONE_RPC_HOST=
DRONE_RPC_PROTO=http
DRONE_RPC_SECRET=
DRONE_DOCKER_CONFIG=/root/.docker/config.json

docker run -d \
-v /var/run/docker.sock:/var/run/docker.sock \
-e DRONE_RPC_PROTO=${DRONE_RPC_PROTO} \
-e DRONE_RPC_HOST=${DRONE_RPC_HOST} \
-e DRONE_RPC_SECRET=${DRONE_RPC_SECRET} \
-e DRONE_RUNNER_CAPACITY=2 \
-e DRONE_RUNNER_NAME=${HOSTNAME} \
-e PATH=$PATH:/usr/sbin \
-p 3000:3000 \
--restart always \
--name runner \
--network host \
drone/drone-runner-docker:1