#!/bin/bash

# Get user inputs for variables
read -p "Enter the desired site name: " site_name
read -p "Enter the site URL (domain or server IP): " site_url
read -p "Enter the WordPress database name: " db_name
read -p "Enter the WordPress database user: " db_user
read -s -p "Enter the WordPress database password: " db_password
echo

# 1: Update and upgrade
sudo apt update
sudo apt upgrade -y

# 2: Make the directory for the new site
sudo mkdir -p /var/www/$site_name

# 3: Download and extract WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
sudo tar xf latest.tar.gz -C /var/www/
sudo mv /var/www/wordpress /var/www/$site_name
rm -rf /tmp/latest.tar.gz*
cd /var/www/

# 4: Ensure group ownership and permissions
sudo chown -R www-data:www-data /var/www/$site_name
sudo chmod -R 755 /var/www/$site_name

# 5: Install Nginx, MySQL, PHP, and other utilities
sudo apt install -y nginx mysql-server php-fpm php-mysql

# 6: Check if MySQL root password is provided, if not, prompt for it
if [ -z "$mysql_root_password" ]; then
    read -s -p "Enter MySQL root password: " mysql_root_password
fi

# 7: Initialize MySQL, create WordPress database, and user
sudo mysql -u root -p"$mysql_root_password" <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS $db_name;
CREATE USER IF NOT EXISTS '$db_user'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '$db_password';
GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';
ALTER USER '$db_user'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '$db_password';
FLUSH PRIVILEGES;
SHOW DATABASES LIKE '$db_name';
SELECT user, host, plugin FROM mysql.user WHERE user='$db_user' AND host='localhost';
EXIT;
MYSQL_SCRIPT



# 8: Configure Nginx virtual host
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

# 9: Create a symbolic link to sites-enabled
sudo ln -s /etc/nginx/sites-available/$site_name /etc/nginx/sites-enabled/
sudo systemctl restart nginx

# 10: Install Certbot, allow ports, configure Certbot, and set up cronjob
sudo apt install -y python3-certbot-nginx
sudo ufw allow 80
sudo ufw allow 443
sudo certbot --nginx
(crontab -l 2>/dev/null; echo "0 0 1 * * certbot --nginx renew") | crontab -
