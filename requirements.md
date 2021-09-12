REQUIREMENTS
============

> In order to play the demo you will have to install the following tools:

# For k3s

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

# k3sup installation

```
curl -sLS https://get.k3sup.dev | sh
sudo install k3sup /usr/local/bin/

k3sup --help
```

- https://github.com/alexellis/k3sup#download-k3sup-tldr


# k3d

**Linux:**
```
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
```

**Mac:**
```
brew install k3d
```

- https://k3d.io/


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
helm repo add stable https://charts.helm.sh/stable
```

# For local demo

## Multipass
Multipass is a VM manager of Ubuntu, working on Windows, MacOs and Linux:

- https://multipass.run/

## Vagrant
Vagrant is a tool for building and managing virtual machine environments in a single workflow. 

- https://www.vagrantup.com/downloads.html

## Docker

- https://www.docker.com/