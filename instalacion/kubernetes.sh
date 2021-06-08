# Requisitos:

## Docker o similar. (containerD, CRIO)
##Pero con una configuración especial del driver cgroups
sudo sed -i 's/--containerd=\/run\/containerd\/containerd.sock/--containerd=\/run\/containerd\/containerd.sock  --exec-opt native.cgroupdriver=systemd/' /lib/systemd/system/docker.service
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    
## Desctivar el SWAPPING
sudo swapoff -a
#sudo sed -i 's/\/swap/#\/swap/' /etc/fstab
sudo sed -i 's/\/var/#\/var/' /etc/fstab

############ INSTALACION DE KUBERNETES
# Alta del repo de Kubernetes:
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y

# Inicializacion del cluster
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Definir la red de kubernetes:
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml


# Activar autocompletado kubectl
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.

# OJO. ESTO NO LO HARIA NUNCA EN PRODUCCION !!!!!
kubectl taint nodes --all node-role.kubernetes.io/master-

