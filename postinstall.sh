#!/bin/bash
# Post-Installation Script

# Refresh
source ~/.bashrc

# Check commands
conda
docker
nvidia-docker
nvcc -V
nvidia-smi

# Create environment
conda create --name tf-gpu python=3.7

# Activate environment
conda activate tf-gpu

# Download packages
pip install tensorflow-gpu
pip install jupyter

# Run Jupyter Notebook
jupyter notebook --allow-root