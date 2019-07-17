# Parent image
FROM baseImage

# Working directory
WORKDIR /gpu

# Copy current directory contents into container at /<WORK_DIR_NAME>
COPY . /gpu

# Install needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Make port available to world outside container
# EXPOSE <port>

# Define environment variable
# ENV 

# Run gpu.py when container launches
# CMD 