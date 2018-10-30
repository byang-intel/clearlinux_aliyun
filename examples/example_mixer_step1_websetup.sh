#!/bin/bash -e

mkdir -p $HOME/mixer
sudo mkdir -p /var/www
sudo ln -sf $HOME/mixer/update/www /var/www/mixer 
sudo mkdir -p /etc/nginx/conf.d
sudo cp -f /usr/share/nginx/conf/nginx.conf.example /etc/nginx/nginx.conf

cat | sudo tee /etc/nginx/conf.d/mixer.conf <<__EOF__
server {
	server_name localhost;
	location / {
		root /var/www/mixer;
		autoindex on;
	}
}
__EOF__
sudo systemctl daemon-reload
sudo systemctl enable nginx
sudo systemctl start nginx

links http://localhost

echo "Done successfully"

