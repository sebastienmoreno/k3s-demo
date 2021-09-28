K3S WITH EXTERNAL VM
====================

Quick demontration of K3S with external VM

# K3S

## Deploy Remote K3S cluster

**Preparation**

```sh
# Set your external IP VM for demo
export SERVER_IP=_______IP_______
export SECOND_SERVER_IP=_______IP_______
export THIRD_SERVER_IP=_______IP_______
export AGENT1_IP=_______IP_______
export AGENT2_IP=_______IP_______
export AGENT3_IP=_______IP_______

# Set your keypair and user for ssh login:
export KEY_LOCATION=~/.ssh/k3s-demo.pem
export SUDO_USERNAME=ec2-user
```

## Demo

***Custom install:***

```sh
# Connect to node
ssh $SUDO_USERNAME@$SERVER_IP -i $KEY_LOCATION

# On the node: 
sudo su
wget https://github.com/k3s-io/k3s/releases/download/v1.21.5%2Bk3s1/k3s
chmod +x k3s
k3s -h 
nohup ./k3s server --cluster-init --write-kubeconfig-mode "0644" --tls-san ${SERVER_IP}  &

# Get Kubeconfig file
scp -i $KEY_LOCATION $SUDO_USERNAME@$SERVER_IP:/etc/rancher/k3s/k3s.yaml kubeconfig 
# replace Ip in kubeconfig
vi or sed -i "s/127.0.0.1/${SERVER_IP}/g" kubeconfig
```

**Installation using k3sup:**

```sh
# add first server
k3sup install --ip $SERVER_IP --ssh-key $KEY_LOCATION --user $SUDO_USERNAME --cluster  --k3s-version v1.21.5+k3s1

# add 2nd server node
k3sup join --server-ip $SERVER_IP --ip $SECOND_SERVER_IP --user $SUDO_USERNAME --server --ssh-key $KEY_LOCATION --k3s-version v1.21.5+k3s1

# add 3nd server node
k3sup join --server-ip $SERVER_IP --ip $THIRD_SERVER_IP --user $SUDO_USERNAME --server --ssh-key $KEY_LOCATION --k3s-version v1.21.5+k3s1


# add worker nodes
k3sup join --server-ip $SERVER_IP --ip $AGENT1_IP --ssh-key $KEY_LOCATION --user $SUDO_USERNAME --k3s-version v1.21.5+k3s1

k3sup join --server-ip $SERVER_IP --ip $AGENT2_IP --ssh-key $KEY_LOCATION --user $SUDO_USERNAME --k3s-version v1.21.5+k3s1

k3sup join --server-ip $SERVER_IP --ip $AGENT3_IP --ssh-key $KEY_LOCATION --user $SUDO_USERNAME --k3s-version v1.21.5+k3s1
```

**Verifications:**

```sh
export KUBECONFIG=$(pwd)/kubeconfig

# Verification
kubectl get nodes -o wide

# check the master node
ssh $SUDO_USERNAME@$SERVER_IP -i $KEY_LOCATION
```

## Post-installation of cluster

**Install Dashboard:**

```sh
kubectl create ns kubernetes-dashboard
helm install kubernetes-dashboard --namespace kubernetes-dashboard helm-charts/dashboard

open "https://${AGENT1_IP}:30001"
```

**Install test app:**

```sh
kubectl create ns test
helm install test --namespace test --set ingress.host=${AGENT1_IP}.nip.io helm-charts/simplenodewebapp
```

**Test the app:**

```sh
./loopcurl "http://${AGENT1_IP}.nip.io"
```