#!/bin/bash

curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi

sudo apt-get update
sudo apt-get install docker-compose-plugin

sudo apt-get install git

# Install k3s Pre-requisites
echo " cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" | sudo tee -a /boot/cmdline.txt

sudo curl -sfL https://get.k3s.io | sh -s - -write-kubeconfig-mode 644
sudo chmod 755 /etc/rancher/k3s/k3s.yaml
mkdir ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chmod 755 ~/.kube/config

systemctl status k3s.service

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm -n kube-system delete traefik traefik-crd
kubectl -n kube-system delete helmchart traefik traefik-crd
touch /var/lib/rancher/k3s/server/manifests/traefik.yaml.skip
systemctl restart k3s

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py

pip install openshift pyyaml kubernetes
