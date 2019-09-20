TALK K3S DEMONSTRATION
======================

Demo repo for K3S Testing

# K3S DEMO

## Create VM
```
multipass launch --name k3s-server --cpus 1 --mem 512M --disk 3G
multipass launch --name k3s-node1 --cpus 1 --mem 512M --disk 3G
multipass launch --name k3s-node2 --cpus 1 --mem 512M --disk 3G
multipass launch --name k3s-node3 --cpus 1 --mem 512M --disk 3G
```

## Master Server installation
Inside server VM:
```
sudo su -
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v0.9.1" INSTALL_K3S_EXEC="--disable-agent --bind-address $(hostname -I)" sh -
```

**Verify installation**
```
systemctl k3s status
journalctl -u k3s -e -f
kubectl get all --all-namespaces
```

**Locate config files**
```
# Kubeconfig
/etc/rancher/k3s/k3s.yaml

# K3S Installation
/var/lib/rancher/k3s
```

## Agents installation

```
K3S_SERVER_URL="https://$(multipass info k3s-server | grep "IPv4" | awk -F' ' '{print $2}'):6443"
K3S_SERVER_TOKEN="$(multipass exec k3s-server -- /bin/bash -c "sudo cat /var/lib/rancher/k3s/server/node-token")"

multipass exec k3s-node1 -- /bin/bash -c "curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v0.9.1" K3S_TOKEN=${K3S_SERVER_TOKEN} K3S_URL=${K3S_SERVER_URL} sh -"
multipass exec k3s-node2 -- /bin/bash -c "curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v0.9.1" K3S_TOKEN=${K3S_SERVER_TOKEN} K3S_URL=${K3S_SERVER_URL} sh -"
multipass exec k3s-node3 -- /bin/bash -c "curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v0.9.1" K3S_TOKEN=${K3S_SERVER_TOKEN} K3S_URL=${K3S_SERVER_URL} sh -"
```

**Verifications**
```
kubectl get nodes
multipass exec k3s-server -- /bin/bash -c "sudo cat /var/lib/rancher/k3s/server/cred/node-passwd"
```

## Resources Consumption
From the host:
```
multipass info --all
```

Inside the VM:
```
# Get process comsumption
ps aux | grep k3s

# Get the top 10 CPU consuming process
ps aux | sort -n -k 3 | tail -10

# Get the top 10 memory consuming process
ps aux | sort -n -k 4 | tail -10
```

## Apps Installation

**Connect to Kubernetes API**
From the host:
```
multipass exec k3s-server -- /bin/bash -c "sudo cat /etc/rancher/k3s/k3s.yaml" > kubeconfig.yml
export KUBECONFIG="$PWD/kubeconfig.yml"

```

### Init Helm

```
kubectl apply -f kube-yml/rbac-tiller.yml
helm init --service-account tiller --history-max 200 
```

> https://github.com/helm/helm/blob/master/docs/rbac.md

### Kubernetes dashboard
```
helm install stable/kubernetes-dashboard --name kubernetes-dashboard --namespace kube-system -f helm-values/dashboard-values.yml
```

### Install application
```
helm install --name test --namespace test --set ingress.host=$(multipass info k3s-node1 | grep "IPv4" | awk -F' ' '{print $2}').xip.io helm-charts/simplenodewebapp
./loopcurl http://$(multipass info k3s-node1 | grep "IPv4" | awk -F' ' '{print $2}').xip.io
```


```
kubectl create ns test
kubectl -n test run nginx --image=nginx --replicas=3 --expose --labels='app=nginx' --port 80

cat <<EOF > ingress-config.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress
spec:
  rules:
  - host: $(multipass info k3s-node1 | grep "IPv4" | awk -F' ' '{print $2}').xip.io
    http:
      paths:
      - path: /
        backend:
          serviceName: nginx
          servicePort: 80
EOF

kubectl apply -f ingress-config.yaml -n test

curl http://$(multipass info k3s-node1 | grep "IPv4" | awk -F' ' '{print $2}').xip.io

kubectl -n test logs -f -l app=nginx --all-containers=true

```
