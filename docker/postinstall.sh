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
conda create --name jupyter_env python=3.7

# Activate environment
conda activate jupyter_env

# Download packages
pip install tensorflow-gpu
pip install jupyter
pip install keras

# Run Jupyter Notebook
jupyter notebook --allow-root