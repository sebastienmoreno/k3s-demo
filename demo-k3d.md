DEMO WITH K3D
=============

> This demo deploy a k3d Kubernetes cluster
Requirements: Docker installed

# K3D Examples

**Launch cluster:**
```
k3d create --publish 8081:30001@k3d-k3s-default-worker-0 --publish 8080:80 --workers 2
```

```
export KUBECONFIG="$(k3d get-kubeconfig --name='k3s-default')"
```

# Test deployment

```
kubectl create ns kubernetes-dashboard
helm install kubernetes-dashboard --namespace kubernetes-dashboard helm-charts/dashboard
```

```
kubectl create ns test
helm install test --namespace test helm-charts/simplenodewebapp
```

```
./loopcurl "http://localhost:8080"
```

