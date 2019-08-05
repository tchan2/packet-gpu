#!/bin/bash
# Post-Installation Script

# Enter as user
su - user

# Refresh
source ~/.bashrc

# Check commands
docker
nvidia-docker
conda
nvcc -V
nvidia-smi

# Create environment
conda create --name jupyter_env python=3.7

# Activate environment
source activate jupyter_env

# Download packages
pip install tensorflow-gpu
pip install jupyter
pip install keras

# Run Jupyter Notebook
jupyter notebook