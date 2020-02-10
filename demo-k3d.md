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

