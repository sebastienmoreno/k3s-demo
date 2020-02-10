REQUIREMENTS
============

> In order to play the demo you will have to install the following tools:

# For K3S

## Install Kubectl

**Linux:**
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

chmod +x ./kubectl
```

**Mac OS:**
```
brew install kubernetes-cli
```

> https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/#installer-kubectl-sur-macos


## Helm Installation

**Installation:**
[https://helm.sh/docs/intro/install/]

**For MacOs:**
```
brew install kubernetes-helm
```

**Linux:**
```
curl -L https://git.io/get_helm.sh | bash
```

**Add a default repository:**
```
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
```

