# Parent image
FROM continuum/anaconda3

# ADD /environment.yml
# Set working directory
# WORKDIR /machine-learning

# Copy current directory contents into container
# COPY . /machine-learning

# Install necessary packages
RUN pip install -r requirements

# Make port 8888 available to outside container
EXPOSE 8888

# Env vars
# ENV

# Run commands from inside container
CMD conda create --name your_env_name python=3.7
CMD conda activate your_env_name
CMD pip install tensorflow-gpu
CMD pip install jupyter
CMD jupyter notebook --allow-root