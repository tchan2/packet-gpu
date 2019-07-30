#!/bin/bash -x
(exec | tee stdout.log) 3>&1 1>&2 2>&3 | tee stderr.log

echo "Running script and downloading essentials.."
sudo apt-get update 
sudo apt-get install -y  build-essential
sudo apt-get install -y linux-headers-$(uname -r)

echo "Downloading Conda"
wget -O anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh
sha256sum anaconda.sh | awk '$1=="45c851b7497cc14d5ca060064394569f724b67d9b5f98a926ed49b834a6bb73a" {print "good!"}'
bash anaconda.sh -b -p $HOME/anaconda

source ~/.bashrc

echo "Downloading Docker CE..."
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint -y 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update 
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
echo "Check if Docker-CE has been installed..."
docker

echo "Adding package repositories for nvidia-docker..."
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

echo "Downloading Nvidia-Docker..." 
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

echo "Check if nvidia-docker has been downloaded."
nvidia-docker

echo "Downloading Cuda..."
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_10.1.168-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_10.1.168-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt-get update
sudo apt-get install -y cuda
echo "export LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-10.1/lib64" >> ~/.bashrc
echo "export PATH=$PATH:/usr/local/cuda-10.1/bin" >> ~/.bashrc
nvcc -V

echo "Unloading unnecessary drivers..."
sudo rmmod nvidia_drm nvidia_modeset nvidia_uvm nvidia
sudo lsof /dev/nvidia*
nvidia-smi

echo "Test if Tensorflow can see the GPU..."
docker run --runtime=nvidia -i --rm tensorflow/tensorflow:latest-gpu python -c "import tensorflow as tf; print(tf.contrib.eager.num_gpus())"

echo "Completed. Script finished."

