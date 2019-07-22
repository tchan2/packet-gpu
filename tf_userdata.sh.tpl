#!/bin/bash -v
echo "Running script and downloading essentials.."
sudo apt-get update 
sudo apt-get install -y  build-essential
sudo apt-get install -y linux-headers-$(uname -r)

echo "Downloading Cuda..."
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_10.1.168-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_10.1.168-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt-get update
sudo apt-get install -y cuda
export LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-10.1/lib64
export PATH=$PATH:/usr/local/cuda-10.1/bin
nvcc -V

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

echo "Checking for nvidia drivers..."
nvidia-smi

echo "Test if Tensorflow can see the GPU..."
docker run --runtime=nvidia -i --rm tensorflow/tensorflow:latest-gpu python -c "import tensorflow as tf; print(tf.contrib.eager.num_gpus())"

echo "Download finished."
echo "Running Jupyter Notebook with GPU support..."

{* echo "Rebooting server..."
sudo shutdown -r now *}

{* echo "Downloading nvidia-docker..."
sudo nvidia-docker-plugin &
echo "Downloaded. Now checking for nvidia-drivers inside Docker container..."
sudo nvidia-docker run --rm nvidia/cuda nvidia-smi *}

{* echo "Running Docker container with Jupyter" *}
{* Checks if Tensorflow can detect the GPU *}
{* docker run --runtime=nvidia -i --rm tensorflow/tensorflow:latest-gpu python -c "import tensorflow as tf; print(tf.contrib.eager.num_gpus())" *}

{* sudo nvidia-docker run --rm --name tf-gpu -p 8888:8888 -p 6006:6006 gcr.io/tensorflow/tensorflow:latest-gpu jupyter notebook --allow-root *}
echo "Completed. Script finished."

