#!/bin/bash -i
# Checks your installations, and runs Jupyter notebook locally.
# If you would like to access your Jupyter notebook through a SSL-enabled domain name, please run the other script!

# Set environment name
env_name=jupyter_env

# Begin script
printf "STARTING SCRIPT.\n"

# Refresh
printf "\nREFRESHING BASHRC...\n"
source ~/.bashrc
printf "Done!\n"

# Check commands
printf "\nCHECKING COMMANDS..."
printf "\nDOCKER\n"
docker

printf "\nNVIDIA-DOCKER\n"
nvidia-docker

printf "\nNVIDIA CUDA COMPILER\n"
if nvcc -V; then
    printf"\n"
else
    printf "nvcc -V not found. Refreshing /.bashrc...\n"
    source ~/.bashrc
fi 

printf "\nNVIDIA DRIVERS\n"
nvidia-smi

printf "\nCONDA\n"
if conda; then 
    printf "\n"
else
    printf "conda not found. Refreshing ~/.bashrc...\n"
    source ~/.bashrc
fi

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

printf "\nRUNNING JUPYTER NOTEBOOK...\n"
jupyter notebook