# Parent image
FROM nvcr.io/nvidia/tensorflow:latest-gpu

# Working directory
WORKDIR /docker

# Copy current directory contents into container at /<WORK_DIR_NAME>
COPY . /docker

# Install needed packages specified in requirements.txt
RUN apt-get update && apt-get install -q -y \
RUN wget -O - -q 'https://gist.githubusercontent.com/dte/8954e405590a360614dcc6acdb7baa74/raw/d1b5a01ed0b9252654016d2a9a435dc8b4c045e7/install-CUDA-docker-nvidia-docker.sh' | sudo bash \
RUN shutdown -r now

# Check that GPU has been installed and that Docker can see it
RUN nvidia-smi \
sudo nvidia-docker-plugin & \
sudo nvidia-docker run --rm nvidia/cuda nvidia-smi

# Install Jupyter
RUN pip install jupyter \
nvidia-docker run --rm --name tf-gpu -p 8888:8888 -p 6006:6006 gcr.io/tensorflow/tensorflow:latest-gpu jupyter notebook --allow-root

# Make port available to world outside container
EXPOSE 8888

# Define environment variable
ENV LIBRARY_PATH = $LD_LIBRARY_PATH:/usr/local/cuda-10.1/lib64
ENV PATH = $PATH:/usr/local/cuda-10.1/bin

# Run app.py when container launches
# CMD ["python", "app.py"]