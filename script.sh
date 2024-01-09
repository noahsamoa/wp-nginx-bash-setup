#!/bin/bash

# Get user inputs for variables
read -p "Enter the desired site name: " site_name
read -p "Enter the site URL (domain or server IP): " site_url

# 1: Set up A record for new site_name on registrar, pointing to host IP

# 2: Update and install Nginx
sudo apt update
sudo apt upgrade -y
sudo apt install -y nginx

# 3: Make the directory for the new site
sudo mkdir -p /var/www/$site_name

# 4: Download and extract WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
sudo tar xf latest.tar.gz -C /var/www/
sudo mv /var/www/wordpress /var/www/$site_name

# 5: Ensure group ownership and permissions
sudo chown -R www-data:www-data /var/www/$site_name
sudo chmod -R 755 /var/www/$site_name

# 6: Install Nginx, MySQL, PHP, and other utilities
sudo apt install -y nginx mysql-server php-fpm php-mysql

# # 7-9: Initialize MySQL and create WordPress database and user
# sudo mysql_secure_installation
# sudo mysql -u root -p <<MYSQL_SCRIPT
# CREATE DATABASE wordpress;
# CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'your_password';
# GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';
# FLUSH PRIVILEGES;
# EXIT;
# MYSQL_SCRIPT

# 10-11: Configure Nginx virtual host
# sudo nano /etc/nginx/sites-available/$site_name
# Add the Nginx configuration (see provided configuration in the task list)
# Add the Nginx configuration
echo "server {
    listen 80;
    server_name $site_url;

    root /var/www/$site_name/wordpress;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}" | sudo tee /etc/nginx/sites-available/$site_name

# 12: Create a symbolic link to sites-enabled
sudo ln -s /etc/nginx/sites-available/$site_name /etc/nginx/sites-enabled/
sudo systemctl restart nginx

# 13-17: Install Certbot, allow ports, configure Certbot, and set up cronjob
sudo apt install -y python3-certbot-nginx
sudo ufw allow 80
sudo ufw allow 443
sudo certbot --nginx
(crontab -l 2>/dev/null; echo "0 0 1 * * certbot --nginx renew") | crontab -
