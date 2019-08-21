#!/bin/bash -v
# Post-Installation Script that checks your installations, and creates a Python environment for your Jupyter notebook.
# This notebook can only be accessed locally. If you would like to secure your notebook with HTTPS and enter it through a domain name, please run `sslwrap.sh` after running this script.

user=user
env_name=jupyter_env

# Enter as user
su - $user

# Refresh
source ~/.bashrc

# Check commands
docker
nvidia-docker
conda
nvcc -V
nvidia-smi

# Create environment
conda create --name $env_name python=3.7

# Activate environment
source activate $env_name

# Download packages
pip install --user tensorflow-gpu
pip install --user jupyter
pip install --user keras

# Run Jupyter Notebook
jupyter notebook