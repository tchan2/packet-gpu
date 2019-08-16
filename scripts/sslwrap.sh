#!/bin/bash
## Please run the postinstall.sh script before running this one, if you have not created a Jupyter notebook yet. You should be signed in as `user`. If you have already created a notebook, feel free to use that one!
## Now, create a domain name on no-ip.com (or any other site you would like to use) and point it to your public IPV4 address. Then, run this script to enable your Jupyter notebook with SSL, and quickly access it through a secure domain name!

domain=your.domain.name

## Get UFW
sudo apt-get update
sudo apt-get install ufw
sudo ufw allow OpenSSH
sudo ufw enable

## Generate a Jupyter notebook configuration file
jupyter notebook --generate-config

## Add the following lines to your config file.
echo "c.NotebookApp.allow_origin = '*'
      c.NotebookApp.ip = '0.0.0.0'
      c.NotebookApp.open_browser = False
      c.NotebookApp.custom_display_url = 'https://$domain'" >> .jupyter/jupyter_notebook_config.py

## Install Nginx
sudo apt-get update
sudo apt-get install nginx

## Install Certbot
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx

## Allow Nginx HTTPS
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'

## Comment out all lines in file
sed -i "s/.*/#&/" /etc/nginx/sites-available/$domain
echo "server {
        server name $domain
        location \ {
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header Host $http_host;
            proxy_pass "http://127.0.0.1:8888";
        }

        listen [::]
      }" >> /etc/nginx/sites-available/$domain

## Obtain a SSL Certificate
echo "2" | sudo certbot --nginx -d $domain