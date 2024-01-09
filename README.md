# WordPress Nginx Setup Script

## Instructions

1. Run the script using `bash script.sh`.
2. Follow the prompts to enter the desired site name and site URL (domain or server IP).
3. Manually set up an A record on your domain registrar for the specified site name.
4. Review the Nginx virtual host configuration at `/etc/nginx/sites-available/your_site_name` if necessary.
5. Access your WordPress site via the specified site URL.

**Note:** Some MySQL-related steps are commented out by default. Uncomment and customize them if you want to automate MySQL setup.

Feel free to tailor the script to your specific requirements and review the logs in case of any errors during the execution.

---

This bash script automates the setup process for a WordPress site on an Nginx server. It covers the following steps:

1. **Set Up A Record:**
   - Manually set up an A record for the desired site name on your domain registrar, pointing to the host's IP address.

2. **Update and Install Nginx:**
   - Update the system packages and install Nginx.

3. **Create Directory for the New Site:**
   - Create the necessary directory structure for the new site.

4. **Download and Extract WordPress:**
   - Download the latest WordPress version, extract it, and move it to the site directory.

5. **Ensure Group Ownership and Permissions:**
   - Set the group ownership and permissions for the site directory.

6. **Install Nginx, MySQL, PHP, and Other Utilities:**
   - Install Nginx, MySQL server, PHP-FPM, and PHP-MySQL.

7-9. **Initialize MySQL and Create Database/User (commented out):**
   - Initialize MySQL and create a WordPress database and user (commented out by default).

10-11. **Configure Nginx Virtual Host:**
   - Configure the Nginx virtual host for the new site.

12. **Create Symbolic Link to Sites-Enabled:**
   - Create a symbolic link to enable the Nginx site configuration.

13-17. **Install Certbot, Allow Ports, Configure Certbot, and Set Up Cronjob:**
   - Install Certbot for SSL, allow ports 80 and 443, configure Certbot, and set up a cronjob for certificate renewal.
