cd master
vagrant up
cd ../agents
vagrant up

export K3S_ID_MASTER=$(vagrant global-status | grep master | awk '{print $1}')
export K3S_ID_AGENT1=$(vagrant global-status | grep agent1 | awk '{print $1}')
export K3S_ID_AGENT2=$(vagrant global-status | grep agent2 | awk '{print $1}')

vagrant ssh -c 'curl -sfL https://get.k3s.io | sh -' $K3S_ID_MASTER

sleep 20

K3S_NODEIP_MASTER=$(vagrant ssh -c "hostname -I" $K3S_ID_MASTER | awk '{print $2}')
K3S_TOKEN=$(vagrant ssh -c "sudo cat /var/lib/rancher/k3s/server/node-token" $K3S_ID_MASTER)

vagrant ssh -c "curl -sfL https://get.k3s.io | K3S_TOKEN=${K3S_TOKEN} K3S_URL=${K3S_NODEIP_MASTER} sh -" $K3S_ID_AGENT1
vagrant ssh -c "curl -sfL https://get.k3s.io | K3S_TOKEN=${K3S_TOKEN} K3S_URL=${K3S_NODEIP_MASTER} sh -" $K3S_ID_AGENT2

vagrant ssh -c "sudo cat /etc/rancher/k3s/k3s.yaml" $K3S_ID_MASTER > ./kubeconfig.yml
sed -i -e "s/localhost/$K3S_NODEIP_MASTER/g" ./kubeconfig.yml

export KUBECONFIG=./kubeconfig.yml

kubectl get all --all-namespaces
