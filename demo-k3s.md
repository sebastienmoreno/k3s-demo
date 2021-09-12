K3S WITH EXTERNAL VM
====================

Quick demontration of K3S with external VM

# K3S

## Deploy Remote K3S cluster
**Preparation**
```
# Set your external IP VM for demo
export SERVER_IP=_______IP_______
export NEXT_SERVER_IP=_______IP_______
export AGENT1_IP=_______IP_______
export AGENT2_IP=_______IP_______

# Set your keypair and user for ssh login:
export KEY_LOCATION=~/.ssh/k3s-demo.pem
export SUDO_USERNAME=ec2-user
```

**Demo**
```
# add the master node
k3sup install --ip $SERVER_IP --ssh-key $KEY_LOCATION --user $SUDO_USERNAME --cluster

# add worker nodes
k3sup join --server-ip $SERVER_IP --ip $AGENT1_IP --ssh-key $KEY_LOCATION --user $SUDO_USERNAME

k3sup join --server-ip $SERVER_IP --ip $AGENT2_IP --ssh-key $KEY_LOCATION --user $SUDO_USERNAME

# add another master node
k3sup join --server-ip $SERVER_IP --ip $NEXT_SERVER_IP --user $SUDO_USERNAME --server --ssh-key $KEY_LOCATION
```

**Verifications:**
```
export KUBECONFIG=$(PWD)/kubeconfig

# Verification
kubectl get nodes -o wide

# check the master node
ssh $SUDO_USERNAME@$SERVER_IP -i $KEY_LOCATION

```

## Post-installation of cluster

**Install Dashboard:**
```
kubectl create ns kubernetes-dashboard
helm install kubernetes-dashboard --namespace kubernetes-dashboard helm-charts/dashboard

open "https://${AGENT1_IP}:30001"
```

**Install test app:**
```
kubectl create ns test
helm install test --namespace test --set ingress.host=${AGENT1_IP}.nip.io helm-charts/simplenodewebapp
```

```
./loopcurl "http://${AGENT1_IP}.nip.io"
```