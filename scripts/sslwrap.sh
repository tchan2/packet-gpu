#!/bin/bash
## Please run the postinstall.sh script before running this one, if you have not created a Jupyter notebook yet. You should be signed in as `user`. If you have already created a notebook, feel free to use that one!
## Now, create a domain name on no-ip.com (or any other site you would like to use) and point it to your public IPV4 address. Then, run this script to enable your Jupyter notebook with SSL, and quickly access it through a secure domain name!

remote_addr='$remote_addr'
http_host='$http_host'
request_uri='$request_uri'

# Set your domain name here
domain=your.domain.name

# Set your email here
email=your@email.com

# Begin sslwrap.sh
printf "STARTING SSLWRAP.SH SCRIPT.\n"

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
c.NotebookApp.port = 8888
c.NotebookApp.custom_display_url = 'https://$domain'" >> .jupyter/jupyter_notebook_config.py

# Install Nginx
printf "\nINSTALLING NGINX...\n"
sudo apt-get -y install nginx

# Install Certbot
printf "\nINSTALLING CERTBOT...\n"
sudo add-apt-repository -y ppa:certbot/certbot
sudo apt-get -y install python-certbot-nginx

# Allow Nginx HTTPS
printf "\nSETTING UP FIREWALL CONFIG...\n"
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'
sudo ufw allow from 127.0.0.1 to any port 8888

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
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header Host $http_host;
            proxy_pass "http://127.0.0.1:8888";
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


# Obtain a SSL Certificate
printf "\nGETTING SSL CERTIFICATE...\n"
sudo certbot --nginx --agree-tos --email $email -q -d $domain

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