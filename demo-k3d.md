DEMO WITH K3D
=============

> This demo deploy a k3d Kubernetes cluster
Requirements: Docker installed

# Simple Example without systemd with Multipass

## Launch VM
```
multipass launch --name k3s-server --cpus 1 --mem 1G --disk 3G
multipass launch --name k3s-node1 --cpus 1 --mem 1G --disk 3G
multipass launch --name k3s-node2 --cpus 1 --mem 1G --disk 3G
multipass launch --name k3s-node3 --cpus 1 --mem 1G --disk 3G

multipass mount ./mnt/rancher k3s-server:/mnt/rancher
multipass mount ./mnt/rancher k3s-node1:/mnt/rancher
multipass mount ./mnt/rancher k3s-node2:/mnt/rancher
multipass mount ./mnt/rancher k3s-node3:/mnt/rancher
```

## On server:
```
nohup /mnt/rancher/k3s server --disable-agent --bind-address $(hostname -I) &
```

## Get the k3s config files
```
cp /etc/rancher/k3s/k3s.yaml /mnt/rancher
cp /var/lib/rancher/k3s/server/node-token /mnt/rancher
K3S_SERVER_URL="https://$(multipass info k3s-server | grep "IPv4" | awk -F' ' '{print $2}'):6443"
```

## On agents
```
nohup /mnt/rancher/k3s agent --node-token-file /mnt/rancher/node-token --server $K3S_SERVER_URL &

multipass exec k3s-node2 -- sudo su -c "/mnt/rancher/k3s agent --token-file /mnt/rancher/node-token --server https://$(multipass info k3s-server | grep "IPv4" | awk -F' ' '{print $2}'):6443 &"
multipass exec k3s-node3 -- sudo su -c "/mnt/rancher/k3s agent --token-file /mnt/rancher/node-token --server https://$(multipass info k3s-server | grep "IPv4" | awk -F' ' '{print $2}'):6443 &"
```

## Installations

**Dashboard**
```
helm install kubernetes-dashboard stable/kubernetes-dashboard --namespace kube-system -f helm-values/dashboard-values.yml
```

```
kubectl create ns test
helm install test --namespace test --set ingress.host=$(multipass info k3s-node1 | grep "IPv4" | awk -F' ' '{print $2}').xip.io helm-charts/simplenodewebapp
```


# K3D Examples

**Launch cluster:**
```
k3d create --publish 8081:30001@k3d-k3s-default-worker-0 --publish 8080:80 --workers 2
```

```
export KUBECONFIG="$(k3d get-kubeconfig --name='k3s-default')"
```

# Helm init

```
helm install kubernetes-dashboard stable/kubernetes-dashboard --namespace kube-system -f helm-values/dashboard-values.yml
```

```
helm install test --namespace test helm-charts/simplenodewebapp
```

```
./loopcurl "http://$(ipconfig getifaddr en0).xip.io:8080"
```

