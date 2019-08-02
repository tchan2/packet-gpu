#!/bin/bash -v

printf "Create new user...\n"
adduser --disabled-password --gecos "" user
echo 'user ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo
su - user

exec 2> /home/user/stderr.log
pwd

printf "\nRunning script and downloading essentials...\n"
sudo apt-get update 
sudo apt-get install -y  build-essential
sudo apt-get install -y linux-headers-$(uname -r)

printf "\nDownloading Conda...\n"
wget -O /home/user/anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh
sha256sum /home/user/anaconda.sh | awk '$1=="45c851b7497cc14d5ca060064394569f724b67d9b5f98a926ed49b834a6bb73a" {print "good!"}'
bash /home/user/anaconda.sh -b -p /home/user/anaconda 
echo "export PATH=/home/user/anaconda/bin:$PATH" >> /home/user/.bashrc
conda 

printf "\nDownloading Docker CE...\n"
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

--update--
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
printf "\nCheck if Docker-CE has been installed...\n"
docker

printf "\nAdding package repositories for nvidia-docker...\n"
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

printf "\nDownloading nvidia-docker...\n" 
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

printf "Check if nvidia-docker has been downloaded.\n"
nvidia-docker

printf "\nDownloading Cuda...\n"
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_10.1.168-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_10.1.168-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt-get update
sudo apt-get install -y cuda

echo "export LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-10.1/lib64" >> /home/user/.bashrc
echo "export PATH=$PATH:/usr/local/cuda-10.1/bin" >> /home/user/.bashrc
printf "\nChecking Cuda installation...\n"
nvcc -V

if nvidia-smi; then
  echo "Success!"
else
  printf "\nError. Now unloading unnecessary drivers...\n"
  sudo rmmod nvidia_drm nvidia_modeset nvidia_uvm nvidia
  printf "\nKilling processes using Nvidia.../n"
  sudo kill `sudo lsof /dev/nvidia* | awk '{print $2}' | grep -v PID`
  printf "\nProcesses using Nvidia killed.\n"
  sudo rmmod nvidia

  printf "\nTrying again...\n"
  nvidia-smi
fi

printf "\nTest if Tensorflow can see the GPU...\n"
sudo docker run --runtime=nvidia -i --rm tensorflow/tensorflow:latest-gpu python -c "import tensorflow as tf; print(tf.contrib.eager.num_gpus())"

printf "\nCompleted. Script finished.\n"

