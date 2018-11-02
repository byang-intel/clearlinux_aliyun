#!/bin/bash -e

sudo rm -rf ~/rpms-save
sudo rm -rf ~/mixer
sudo systemctl stop nginx
sudo systemctl disable nginx
sudo rm -rf /var/www /etc/nginx 

echo "Done successfully"

