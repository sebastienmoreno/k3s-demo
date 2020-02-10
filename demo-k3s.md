K3S WITH EXTERNAL VM
====================

Quick demontration of K3S with external VM

# K3S

## Deploy Remote K3S cluster

```
export SERVER_IP=10.122.82.68
export NEXT_SERVER_IP=10.122.82.69
export AGENT1_IP=10.122.82.94
export AGENT2_IP=10.122.82.88

#export KEY_LOCATION=~/.ssh/key.pem
export KEY_LOCATION=~/.ssh/athena-default-keypair.pem
export SUDO_USERNAME=ec2-user

# add the master node
k3sup install --ip $SERVER_IP --ssh-key $KEY_LOCATION --user $SUDO_USERNAME --cluster

# add worker nodes
k3sup join --server-ip $SERVER_IP --ip $AGENT1_IP --ssh-key $KEY_LOCATION --user $SUDO_USERNAME

k3sup join --server-ip $SERVER_IP --ip $AGENT2_IP --ssh-key $KEY_LOCATION --user $SUDO_USERNAME

# add another master node
k3sup join --server-ip $SERVER_IP --ip $NEXT_SERVER_IP --user $SUDO_USERNAME --server --ssh-key $KEY_LOCATION
```

**Verfications:**
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

open "https://${SERVER_IP}:30001"
```

```
kubectl create ns test
helm install test --namespace test --set ingress.host=${AGENT1_IP}.xip.io helm-charts/simplenodewebapp
```

```
./loopcurl "http://${AGENT1_IP}.xip.io"
```