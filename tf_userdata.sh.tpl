#!/bin/bash -v

printf "CREATE NEW USER\n"
adduser --disabled-password --gecos "" user
echo 'user ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo
su - user

exec 2> /home/user/stderr.log
pwd

printf "\nDOWNLOADING ESSENTIALS\n"
sudo apt-get update 
sudo apt-get install -y  build-essential
sudo apt-get install -y linux-headers-$(uname -r)

printf "\nINSTALLING CONDA\n"
wget -O /home/user/anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh
sha256sum /home/user/anaconda.sh | awk '$1=="45c851b7497cc14d5ca060064394569f724b67d9b5f98a926ed49b834a6bb73a" {print "good!"}'
bash /home/user/anaconda.sh -p /home/user/anaconda
printf "\nCHECKING CONDA...\n" 
conda

printf "\nINSTALLING DOCKER CE\n"
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


sudo apt-get install -y docker-ce docker-ce-cli containerd.io
printf "\nCHECKING DOCKER...\n" 
docker

printf "\nADDING PKG REPOS FOR NVIDIA-DOCKER\n"
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

printf "\nINSTALLING NVIDIA DOCKER\n" 
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

printf "\nCHECKING NVIDIA-DOCKER...\n" 
nvidia-docker

printf "\nINSTALLING CUDA\n"
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_10.1.168-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_10.1.168-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt-get update
sudo apt-get install -y cuda

echo "export LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-10.1/lib64" >> /home/user/.bashrc
echo "export PATH=$PATH:/usr/local/cuda-10.1/bin" >> /home/user/.bashrc
printf "\nCHECKING FOR CUDA DRIVER...\n" 
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

printf "\nINSTALLING ELASTICSEARCH\n" 
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install elasticsearch
{* configures elasticsearch to run automatically during boot *}
sudo update-rc.d elasticsearch defaults 95 10

sudo -i services elasticsearch start
printf "\nCHECKING IF ELASTICSEARCH IS RUNNING\n" 
curl -X GET "localhost:9200/"


printf "\nINSTALLING KIBANA\n" 
sudo apt-get update && sudo apt-get install kibana
{* configures kibana to run automatically during boot *}
sudo update-rc.d kibana defaults 95 10

brew services start kibana
printf "\nCHECKING IF KIBANA IS RUNNING (Should not show any output)\n" 
curl -X GET "localhost:5601/"


printf "\nINSTALLING METRICBEAT\n" 
sudo apt-get update && sudo apt-get install metricbeat
{* configures metricbeat to run automatically during boot *}
sudo update-rc.d metricbeat defaults 95 10

brew services start elastic/tap/metricbeat-full
printf "\nCHECKING IF METRICBEAT IS RUNNING\n" 
curl -X GET "curl -X GET "localhost:9200/_cat/indices?v"

printf "\nCHECKING IF TENSORFLOW CAN DETECT GPU...\n"
sudo docker run --runtime=nvidia -i --rm tensorflow/tensorflow:latest-gpu python -c "import tensorflow as tf; print(tf.contrib.eager.num_gpus())"

printf "\nCompleted. Script finished.\n"

