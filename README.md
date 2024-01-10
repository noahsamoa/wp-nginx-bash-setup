# Wordpress Nginx Bash Setup Script

This Bash script automates the setup of a WordPress site on an Nginx server. Follow the steps below for a seamless installation:

### Usage:

1. Run the script:

    ```bash
    bash script.sh
    ```

2. Enter the desired site name, site URL (domain or server IP), WordPress database name, WordPress database user, and WordPress database password as prompted.

### Installation Steps:

1. **Set up A Record:**
   - Manually configure an A record for the specified site name on your domain registrar, pointing to the host's IP.

2. **Review the Automated Installation:**
   - The script will handle the following steps automatically:

   **Update and Upgrade:**

    ```bash
    sudo apt update
    sudo apt upgrade -y
    ```

   **Create Site Directory:**

    ```bash
    sudo mkdir -p /var/www/$site_name
    ```

   **Download and Extract WordPress:**

    ```bash
    cd /tmp
    wget https://wordpress.org/latest.tar.gz
    sudo tar xf latest.tar.gz -C /var/www/
    sudo mv /var/www/wordpress /var/www/$site_name
    ```

   **Set Ownership and Permissions:**

    ```bash
    sudo chown -R www-data:www-data /var/www/$site_name
    sudo chmod -R 755 /var/www/$site_name
    ```

   **Install Nginx, MySQL, PHP, and Utilities:**

    ```bash
    sudo apt install -y nginx mysql-server php-fpm php-mysql
    ```

   **Initialize MySQL and Create WordPress Database/User:**

    ```bash
    sudo mysql_secure_installation
    sudo mysql -u root -p <<MYSQL_SCRIPT
    CREATE DATABASE $db_name;
    CREATE USER '$db_user'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '$db_password';
    GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';
    ALTER USER '$db_user'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '$db_password';
    FLUSH PRIVILEGES;
    EXIT;
    MYSQL_SCRIPT
    ```

   **Configure Nginx Virtual Host:**

    ```bash
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
    ```

   **Create a Symbolic Link to sites-enabled:**

    ```bash
    sudo ln -s /etc/nginx/sites-available/$site_name /etc/nginx/sites-enabled/
    sudo systemctl restart nginx
    ```

    **Install Certbot, Allow Ports, Configure Certbot, and Set Up Cronjob:**

    ```bash
    sudo apt install -y python3-certbot-nginx
    sudo ufw allow 80
    sudo ufw allow 443
    sudo certbot --nginx
    (crontab -l 2>/dev/null; echo "0 0 1 * * certbot --nginx renew") | crontab -
    ```

### Script Customization:

Feel free to customize the script to fit your specific requirements. For detailed information, refer to the script comments and logs in case of errors during execution.
