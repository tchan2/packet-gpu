# Parent image
FROM continuum/anaconda3

# ADD ./postinstall.sh /

# Copy current directory contents into container
COPY ./postinstall.sh /

# Install necessary packages
RUN pip install -r requirements
RUN chmod +x /postinstall.sh

# Make port 8888 available to outside container
EXPOSE 8888

# Env vars
# ENV

# Run commands from inside container
ENTRYPOINT ["postinstall.sh"]