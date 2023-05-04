DEMO WITH K3D
=============

> This demo deploy a k3d Kubernetes cluster
Requirements: Docker installed, k3d installed

# K3D Examples

**Launch cluster:**

```sh
k3d cluster create --agents 2 --port 8081:30001@agent:0 --port 8080:80@loadbalancer
```

**Use Kubeconfig:**

```sh
export KUBECONFIG="$(k3d kubeconfig write 'k3s-default')"
```

# Test deployment

## Install dashboard

```sh
kubectl create ns kubernetes-dashboard
helm install kubernetes-dashboard --namespace kubernetes-dashboard helm-charts/dashboard
```

**Test it:**

```sh
kubectl get all -n kubernetes-dashboard
open "https://localhost:8081"
```

## Install simple node application

```sh
kubectl create ns test
helm install test --namespace test helm-charts/simplenodewebapp
```

**Test the app:**

```sh
./loopcurl "http://localhost:8080"
```

## Test scalability

**Add new nodes:**

```sh
k3d node create agent2 --replicas 5
k3d node list

kubectl get nodes -o wide 
docker ps
```

**Scale the app!**

```sh
kubectl -n test scale --replicas=8 deployment/test-simplenodewebapp
```

**See the pods on various nodes:**

```sh
kubectl -n test get pods
```

**Test the app:**

```sh
./loopcurl "http://localhost:8080"
```