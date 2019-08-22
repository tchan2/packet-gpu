#!/bin/bash
# Post-Installation Script that checks your installations, and creates a Python environment for your Jupyter notebook.
# This notebook can only be accessed locally. If you would like to secure your notebook with HTTPS and enter it through a domain name, please run `sslwrap.sh` after running this script.

# Set environment name
env_name=jupyter_env

# Begin postinstall.sh
printf "STARTING POSTINSTALL.SH SCRIPT.\n"

# Refresh
printf "\nREFRESHING BASHRC...\n"
source ~/.bashrc
printf "Done!\n"

# Update Conda
printf "\nUPDATING CONDA...\n"
echo y | conda update -n base -c defaults conda

# Check commands
printf "\nCHECKING COMMANDS..."
printf "\nDOCKER\n"
docker

printf "\nNVIDIA-DOCKER\n"
nvidia-docker

printf "\nNVIDIA CUDA COMPILER\n"
nvcc -V

printf "\nNVIDIA DRIVERS\n"
nvidia-smi

printf "\nCONDA\n"
conda

# Initialize Conda
printf "\nINITIALIZING CONDA...\n"
conda init

# Create environment
printf "\nCREATING ENVIRONMENT CALLED: '$env_name'...\n"
echo y | conda create --name $env_name python=3.7

# Activate environment
printf "\nACTIVATING ENVIRONMENT...\n"
source activate $env_name

# Download packages
printf "\nINSTALLING PACKAGES..."
printf "\nTENSORFLOW-GPU\n"
pip install --user tensorflow-gpu

printf "\nJUPYTER\n"
pip install --user jupyter

printf "\nKERAS\n"
pip install --user keras

printf "\nSCRIPT COMPLETED.\n"