#!/bin/bash -i
# Please create a domain name on no-ip.com (or any other site you would like to use) and point it to your public IPV4 address. Then, run this script to enable your Jupyter notebook with SSL, and quickly access it through a secure domain name!
# If you don't wish to access your Jupyter notebook through a SSL-enabled domain name, please run the other script!

remote_addr='$remote_addr'
http_host='$http_host'
request_uri='$request_uri'
env_name=jupyter_env

# Set your domain name here
domain=$1
if [ -z "$1" ]
  then
    echo "ERROR: No domain or email given.";
    exit 1;
fi

# Set your email here
email=$2
if [ -z "$2" ]
  then
    echo "ERROR: No email given.";
    exit 1;
fi

# Begin sslwrap.sh
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
    printf "\n"
else
    printf "\nCommand not found. Refreshing ~/.bashrc...\n"
    source ~/.bashrc
fi

printf "\nNVIDIA DRIVERS\n"
nvidia-smi

printf "\nCONDA\n"
if conda; then 
    printf "\n"
else
    printf "\nCommand not found. Refreshing ~/.bashrc...\n"
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

# Get UFW
printf "\nUPDATING...\n"
sudo apt-get -y update

printf "\nINSTALLING FIREWALL...\n"
sudo apt-get -y install ufw

printf "\nALLOWING AND ENABLING OPENSSH...\n"
sudo ufw allow OpenSSH
echo y | sudo ufw enable

# Generate a Jupyter notebook configuration file
printf "\nGENERATING JUPYTER CONFIG FILE...\n"
jupyter notebook -y --generate-config

# Add the following lines to your config file.
printf "\nEDITING JUPYTER CONFIG FILE...\n"
echo "c.NotebookApp.allow_origin = '*'
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.open_browser = False
c.NotebookApp.custom_display_url = 'https://$domain'" >> .jupyter/jupyter_notebook_config.py

# Install Nginx
printf "\nINSTALLING NGINX...\n"
sudo apt-get -y install nginx

printf "\nSTARTING NGINX...\n"
sudo service nginx start

# Install Certbot
printf "\nINSTALLING CERTBOT...\n"
sudo add-apt-repository -y ppa:certbot/certbot
sudo apt-get -y update 
sudo apt-get -y install python-certbot-nginx

# Allow Nginx HTTPS
printf "\nSETTING UP FIREWALL CONFIG...\n"
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'
sudo ufw allow from 127.0.0.1 to any port 8888

# Obtain a SSL Certificate
printf "\nGETTING SSL CERTIFICATE...\n"
sudo certbot --nginx --agree-tos --redirect -q -d $domain --email $email 

# Copy and edit file
printf "\nCOPYING AND COMMENTING OUT FILE...\n"
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$domain
sudo sed -i "s/.*/#&/" /etc/nginx/sites-available/$domain

## Edit file
printf "\nEDITING FILE...\n"
echo "
server {
        server_name $domain;
        location / {
            proxy_pass "http://127.0.0.1:8888";
            proxy_set_header Upgrade "websocket";
            proxy_set_header Connection "Upgrade";
            proxy_http_version 1.1;
        }

        listen [::]:443 ssl ipv6only=on; # managed by Certbot
        listen 443 ssl; # managed by Certbot
        ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem; # managed by Certbot
        ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem; # managed by Certbot
        include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}
    
server {
       listen 80;
       server_name $domain;
       return 301 https://$domain$request_uri;
}" | sudo tee -a /etc/nginx/sites-available/$domain >/dev/null

# Copy and delete certain files
printf "\nEDITING FILES...\n"
sudo cp /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/$domain
sudo rm /etc/nginx/sites-enabled/default 

# Restart Nginx
printf "\nRESTARTING NGINX...\n"
sudo systemctl restart nginx

# Set Jupyter Password
printf "\nSETTING JUPYTER PASSWORD...\n"
printf "\nPlease set a password for your Jupyter notebook.\n"
jupyter notebook password

printf "\nSCRIPT COMPLETED.\n"

# Run Jupyter Notebook
printf "\nRUNNING SSL ENABLED JUPYTER NOTEBOOK...\n"
jupyter notebook