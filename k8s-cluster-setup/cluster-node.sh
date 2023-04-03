#!/bin/bash
###### for all node ######

# Aotomate kubernetes setup on vm cluster
# Author: Deepak Verma

# check script is run as root

# if [ "$UID" -ne 0 ];then
#     echo -e "\033[0;1mYou must  run this script as root switch user by (su -i) and run again! "
#     exit 1
# fi


####print color####
function print_color(){

 NC='\033[0m'
 case $1 in
    "green") COLOR='\033[0;32m' ;;
    "red") COLOR='\033[0;31m' ;;
    "*") COLOR='\033[0m' ;;
  esac

  echo -e "${COLOR}$2 ${NC}"
}

#######################################
# Check the status of a given service. If not active exit script
# Arguments:
#   Service Name. eg: firewalld, mariadb
#######################################
function check_service_status(){
  service_is_active=$(  sudo systemctl is-active $1)

  if [ $service_is_active = "active" ]
  then
    print_color "green" "\n$1 is active and running\n"
  else
    print_color "green" "\n$1 is not active/running\n"
    exit 1
  fi
}


#######################################
# Check the status of a firewalld rule. If not configured exit.
# Arguments:
#   Port Number. eg: 3306, 80
#######################################
function is_firewalld_rule_configured(){

  firewalld_ports=$( sudo firewall-cmd --list-all --zone=public | sudo grep ports)

  if [[ $firewalld_ports == *$1* ]]
  then
    print_color "green" "FirewallD has port $1 configured"
  else
    print_color "green" "FirewallD port $1 is not configured"
    exit 1
  fi
}



##### update system ########

print_color green "\n----------------------------------System updating... wait\n"
sudo apt update
check=$(echo $?)
if [ "$check" -ne 0 ];then
		unset check
		${check:?"Updating is not complete... "}
fi
print_color green "\n----------------------------------System update complete\n"



sleep 5

print_color green "\n----------------------------require configuration\n"
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system


print_color green "\n----------------------------require configuration completed\n"

# Install and configure firewalld

print_color "green" "Installing FirewallD.. "

  sudo apt install -y firewalld

print_color "green" " FirewallD installed successfully "

 sudo service firewalld start
 sudo systemctl enable firewalld



# Check FirewallD Service is running
check_service_status firewalld







print_color green "\n------------------------Configure Firewall rules for node------------------------\n"


print_color green  "\nKubernetes API server port\n"
 sudo  firewall-cmd --permanent --zone=public --add-port=6443/tcp
 sudo  firewall-cmd --reload

is_firewalld_rule_configured 6443

print_color green "\nEtcd server client API port\n"
  sudo firewall-cmd --permanent --zone=public --add-port=2379-2380/tcp
  sudo firewall-cmd --reload
is_firewalld_rule_configured 2379-2380

print_color green "\nKubelet API Self, Control plane port\n"
  sudo firewall-cmd --permanent --zone=public --add-port=10250/tcp
  sudo firewall-cmd --reload
is_firewalld_rule_configured 10250

print_color green "\nKube-scheduler port\n"
  sudo firewall-cmd --permanent --zone=public --add-port=10259/tcp
  sudo firewall-cmd --reload
is_firewalld_rule_configured 10259

print_color green "\nKube-controller-manager port\n"
  sudo firewall-cmd --permanent --zone=public --add-port=10257/tcp
  sudo firewall-cmd --reload
is_firewalld_rule_configured 10257

print_color green "\n------------------------Successfully Configured Firewall------------------------\n"




############## commanet docker section for future troubleshooting####################
: <<'END_COMMENT'

print_color green "--------------Docker Installation and configuration start----------------------"

#docker
curl -fsSL https://get.docker.com -o get-docker.sh
  sh ./get-docker.sh

# check service
check_service_status docker
print_color green "--------------Docker Installation complete--------"


print_color green "-------configure docker to use systemd driver---------"
# Setup daemon.
  cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
  systemctl enable docker
  systemctl restart docker

# check service
check_service_status docker

print_color green "-------configured docker successfully-----"


END_COMMENT

################################################################################



print_color green "--------------Containerd Installation --------"

sudo apt update 
sudo apt install -y containerd
sudo systemctl enable containerd

print_color green "--------------Containerd Installation completed --------"



print_color green "-------configure containerd ---------"

# Configure containerd
sudo mkdir -p /etc/containerd
#containerd config default | sudo tee /etc/containerd/config.toml

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# Restart containerd
sudo systemctl restart containerd
print_color green "-------Successfully configured containerd ---------"







print_color green "-------configure and install kubeadm, kubelet, kubectl----------"

 

sudo wget  https://packages.cloud.google.com/apt/doc/apt-key.gpg
sudo mkdir  -p /etc/apt/keyrings/
sudo touch /etc/apt/keyrings/kubernetes-archive-keyring.gpg
sudo mv  apt-key.gpg  /etc/apt/keyrings/kubernetes-archive-keyring.gpg

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

  #curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

sudo echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" |  sudo  tee /etc/apt/sources.list.d/kubernetes.list


sudo apt-get update
sudo apt-get install -y kubelet kubeadm 
sudo apt-mark hold kubelet kubeadm 


sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

sudo echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

sudo chmod +x kubectl
sudo mkdir -p ~/.local/bin
sudo mv ./kubectl ~/.local/bin/kubectl


kubectlVersion=$(kubectl version --client -o yaml)
major=$( echo ${kubectlVersion} | grep -i major | cut -d ":" -f 11 | cut -d " " -f 2 | sed 's/"//g' )
minor=$( echo ${kubectlVersion} | grep -i minor | cut -d ":" -f 12 | cut -d " " -f 2 | sed 's/"//g' )

print_color green  "\nYour Kubectl version is :-> ${major}.${minor}"


print_color green "-------Successfully configured and install kubeadm, kubelet, kubectl----------"

