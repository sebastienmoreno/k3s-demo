K3S WITH EXTERNAL VM
====================

Quick demontration of K3S with external VM

# K3S

## Deploy Remote K3S cluster

```
export SERVER_IP=184.73.57.227
export NEXT_SERVER_IP=3.219.56.248
export AGENT1_IP=3.81.98.247
export AGENT2_IP=34.207.66.47

k3sup install --ip $SERVER_IP --ssh-key ~/.ssh/key.pem --user ec2-user

k3sup join --server-ip $SERVER_IP --ip $NEXT_SERVER_IP --user ec2-user --server-user ec2-user  --server --ssh-key ~/.ssh/key.pem

k3sup join --server-ip $SERVER_IP --ip $AGENT1_IP --ssh-key ~/.ssh/key.pem --user ec2-user

k3sup join --server-ip $SERVER_IP --ip $AGENT2_IP --ssh-key ~/.ssh/key.pem --user ec2-user

export KUBECONFIG=$(PWD)/kubeconfig

# Verification
kubectl get nodes -o wide

```

## Post-installation of cluster

**Install Dashboard:**
```
helm install kubernetes-dashboard stable/kubernetes-dashboard --namespace kube-system -f helm-values/dashboard-values.yml

open "https://${SERVER_IP}:30001"
```

```
kubectl create ns test
helm install test --namespace test --set ingress.host=${AGENT1_IP}.xip.io helm-charts/simplenodewebapp
```

```
./loopcurl "http://${AGENT1_IP}.xip.io"
```