# WordPress Nginx Setup Script

This Bash script automates the setup of a WordPress site on an Nginx server. Follow the steps below for a seamless installation:

### Usage:

1. Run the script:

    ```bash
    bash script.sh
    ```

2. Enter the desired site name and site URL (domain or server IP) as prompted.

### Installation Steps:

1. **Set up A Record:**
   - Manually configure an A record for the specified site name on your domain registrar, pointing to the host's IP.

2. **Run the Script:**
    ```bash
    bash script.sh
    ```
    Enter the desired site name and site URL (domain or server IP) as prompted.

3. **Review the Automated Installation:**
   - The script will handle the following steps automatically:

   3.1. Update and install Nginx.

   3.2. Create the site directory.

   3.3. Download and extract WordPress.

   3.4. Set ownership and permissions.

   3.5. Install Nginx, MySQL, PHP, and other utilities.

   3.6. [Commented Out] Initialize MySQL and create the WordPress database and user (uncomment and customize if needed).

   3.7. Configure the Nginx virtual host.

   3.8. Create a symbolic link to sites-enabled.

   3.9. Install Certbot, allow ports, configure Certbot, and set up a cronjob for certificate renewal.

4. **Finalize the Installation:**
   - Feel free to customize the script or review logs in case of errors during execution.

Feel free to customize the script further to fit your specific requirements.
