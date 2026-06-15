#!/bin/bash
# Kubernetes node setup script

set -euo pipefail

# so we can view the logs using journalctl in the VM
log() { echo "[$(date '+%H:%M:%S')] $*"  | systemd-cat -p info; }

# -- 1. Firewall ----------------------------------------
log "Configuring UFW..."
ufw --force enable
ufw allow 6443/tcp
log "UFW configured"

# -- 2. Disable swap ------------------------------------
log "Disabling swap..."
swapoff -a
# comment out the swap so it stays off permanently
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
log "Swap disabled"

# -- 3. Configure containerd ----------------------------
log "Configuring containerd..."
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml > /dev/null
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd
log "Containerd configured"

# -- 4. Install kubeadm, kubelet, kubectl ---------------
log "Installing Kubernetes tools..."
apt-get update -qq
apt-get install -y apt-transport-https ca-certificates curl gpg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.36/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.36/deb/ /'  | tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

apt-get update -qq
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
systemctl enable --now kubelet
log "Kubernetes tools installed"

log "Node setup complete."
