# LAMP Server Role

## Description

This role installs and configures a complete LAMP (Linux, Apache, MySQL, PHP) stack on Ubuntu/Debian systems. It sets up Apache web server with virtual host configuration, MySQL database server, and PHP with necessary extensions.

## What This Role Does

1. **LAMP Stack Installation**
   - Installs Apache 2 web server
   - Installs MySQL server
   - Installs PHP runtime
   - Installs mod_php for Apache integration
   - Installs php-mysql extension for database connectivity

2. **Virtual Host Setup**
   - Creates web root directory with proper permissions
   - Deploys virtual host configuration from template
   - Configures Apache to serve the virtual host
   - Disables default Apache site
   - Sets proper ownership (www-data user/group)

3. **Apache Configuration**
   - Enables the custom virtual host site
   - Disables the default Apache site (000-default)
   - Reloads Apache to apply configuration changes

4. **Web Content Deployment**
   - Deploys index.html landing page
   - Deploys info.php for PHP configuration verification

## Requirements

- Ubuntu/Debian-based Linux distribution
- Sudo/root access for package installation
- Network connectivity for package downloads

## Key Variables

```yaml
linux_srv01_hostname: webserver                # Server hostname
web_root_path: /var/www/example                # Web root directory path
web_user: www-data                             # Web server user
web_group: www-data                            # Web server group
web_domain_name: example.com                   # Virtual host domain name
apache_sites_available: /etc/apache2/sites-available  # Apache sites config dir
```

## Example Playbook

```yaml
- name: Setup LAMP server
  hosts: webservers
  become: yes
  vars:
    web_domain_name: mysite.local
    web_root_path: /var/www/mysite
  roles:
    - lamp_server
```

## Notes

- MySQL is installed but not secured (no mysql_secure_installation run)
- Default MySQL root password is not set
- Apache reloads automatically when virtual host configuration changes
- The role deploys basic index.html and info.php files
- PHP info page is accessible at http://yourserver/info.php

## Deployed Files

| File | Purpose |
|------|---------|
| index.html | Main landing page for the website |
| info.php | PHP configuration information page |

## Virtual Host Configuration

The role uses a Jinja2 template (vhost.conf.j2) to create the Apache virtual host configuration. The template should define:
- ServerName
- DocumentRoot
- Directory permissions
- Error and access log locations

## Post-Installation

After running this role:
- Apache is running and serving content
- MySQL is installed and running
- PHP is integrated with Apache
- Virtual host is configured and active
- Web content is accessible via HTTP

## Security Considerations

This role is designed for lab/development environments:
- MySQL root password is not set
- mysql_secure_installation is not run
- PHP info.php exposes server configuration (remove in production)
- No SSL/TLS configuration
- Default firewall rules not configured

For production use:
- Run mysql_secure_installation
- Set MySQL root password
- Remove or protect info.php
- Configure SSL certificates
- Implement firewall rules
- Harden Apache and PHP configurations

## Dependencies

None
