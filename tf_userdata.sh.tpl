#!/bin/bash -v
echo "Running script..."
sudo apt-get update && apt-get install -q -y
echo "Downloading CUDA, Nvidia, etc..."
wget -0 - -q 'https://gist.githubusercontent.com/dte/8954e405590a360614dcc6acdb7baa74/raw/d1b5a01ed0b9252654016d2a9a435dc8b4c045e7/install-CUDA-docker-nvidia-docker.sh' | sudo bash
echo "Download finished."

echo "Rebooting server..."
sudo shutdown -r now

export LIBRARY_PATH = $LD_LIBRARY_PATH:/usr/local/cuda-10.1/lib64
export PATH = $PATH:/usr/local/cuda-10.1/bin

echo "Checking for Nvidia Drivers"
nvidia-smi

echo "Downloading nvidia-docker..."
sudo nvidia-docker-plugin &
echo "Downloaded. Now checking for nvidia-drivers inside Docker container..."
sudo nvidia-docker run --rm nvidia/cuda nvidia-smi

echo "Downloading Jupyter..."
pip install jupyter
echo "Downloaded. Running Jupyter now..."

nvidia-docker run --rm --name tf-gpu -p 8888:8888 -p 6006:6006 gcr.io/tensorflow/tensorflow:latest-gpu jupyter notebook --allow-root
echo "Completed. Script finished."

