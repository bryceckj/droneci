# Drone CI
CI/CD pipeline for automating workflows with containers
https://docs.drone.io/

# Setup

## Drone Server & Runner
To run Drone pipelines, first set up a Drone Server and Runner(s). 
Since Drone is container-native, every component, including the server and runner, can be run as containers. 
Every step of the pipeline is also run as containers. 

### Compute Resources ###
To set up a Drone server container, first provision the necessary compute resources. 
For example, we can use an AWS EC2 instance. For this EC2, ensure the security group allows inbound rules for port 80 (HTTP) and port 3000.

After that, we will configure some pre-requisites, and then spin up a Drone container in the EC2.

## Pre-Reqs: ##

### Mounts ###
If using an NFS, make sure to mount the NFS in the EC2.
`sudo mount -t nfs -o nolock,hard <NFS-SERVER-IP-ADDR>:/scratch /scratch`

### Drone CLI ###
optional: Install Drone CLI: 
`curl -L https://github.com/drone/drone-cli/releases/latest/download/drone_linux_amd64.tar.gz | tar zx`
`sudo install -t /usr/local/bin drone`

### Github Drone Webhook ###
- Log into github.com
- Click on your user menu (top right corner), select Settings
- On the left side menu, select Developer Settings
- Select OAuth Apps
- Create New OAuth App:
    - Application Name: DroneCI
    - Homepage URL: <http://IP-address> 
    - Callback URL: <http://IP-address/login>
- Note down your Client ID and Client Secret

### Push to ECR? ###
If pushing container images to AWS ECR, first login to ECR:
`$(aws ecr get-login --no-include-email --region $region --registry-id $ECR_ACCOUNT_ID)`


## Drone Server
```
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
--env=DRONE_USER_CREATE=username:svcusr,admin:true \
--env=PATH=$PATH:/usr/sbin \
--privileged \
--publish=80:80 \
--publish=443:443 \
--restart=always \
--detach=true \
--name=drone \
--network=host \
drone/drone:1
```

## Drone Runner ##
```
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
```

After setting up the Drone Server and Runner, access the Drone GUI by visiting http://<DRONE_SERVER_HOST_IP>
By default, webhook is tied to push, i.e. every time you push your code to the hooked repository, it will trigger the Drone pipeline.
