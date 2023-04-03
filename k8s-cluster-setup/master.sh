


##### for master node ############

MYIP=$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')

sudo kubeadm init --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address=${MYIP} --cri-socket unix:///var/run/containerd/containerd.sock --ignore-preflight-errors=all

sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sleep 5 



nodejoin=$(kubeadm token create --print-join-command)

cat > k8s-key <<-EOF
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
EOF

ssh -i "k8s-key" -o "StrictHostKeyChecking no" ubuntu@"${1}" sudo ${nodejoin} --ignore-preflight-errors=all
# echo "${nodejoin} --ignore-preflight-errors=all"


sudo kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml


