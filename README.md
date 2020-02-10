K3S DEMONSTRATION
=================

This is a repository containing technical procedure and configs to test a k3s installation (locally and in VM). 

# Requirements

You should first check the [requirements](requirements.md) to install before launching the demo.

# Demos

3 demos are available:
- [Demo with a k3s installation on external VM](demo-k3s.md)
- [Demo with a local Multipass VM](demo-with-multipass.md)
- [Demo with local k3d](demo-k3d.md)


# Monitoring results

## Server installation
### Verify installation
```
systemctl k3s status
journalctl -u k3s -e -f
kubectl get all --all-namespaces
```

### Locate config files
```
# Kubeconfig
/etc/rancher/k3s/k3s.yaml

# K3S Installation
/var/lib/rancher/k3s
```

## Agents installation

### Verify installation
```
kubectl get nodes
multipass exec k3s-server -- /bin/bash -c "sudo cat /var/lib/rancher/k3s/server/cred/node-passwd"
```

## Resources Consumption
**For local multipass:**
```
multipass info --all
```

**Inside the VM:**
```
# Get process comsumption
ps aux | grep k3s

# Get the top 10 CPU consuming process
ps aux | sort -n -k 3 | tail -10

# Get the top 10 memory consuming process
ps aux | sort -n -k 4 | tail -10
```

