# Qoliber DevOps Tools for Magento Projects

## Overview

This repository contains a set of DevOps tools designed to streamline the setup and management of Magento-based projects on Ubuntu servers (20.04 and 22.04). These tools simplify the installation and configuration processes, allowing for quick and efficient setup of development and production environments.

## Folder Structure

### `bin/functions/*`
Contains bash functions to execute single commands with parameters for specified services. These functions are reusable components designed to perform specific tasks.

### `bin/services/*`
Includes installation scripts for various services required to run open-source platforms like Magento. Each script handles the setup and configuration of a specific service.

### `bin/domain.wizard.sh`
A wizard script that guides users through the configuration of everything on the server. It offers a step-by-step guide and allows for the selection of additional options like Mailbag and OPCache for specific projects. The Domain Wizard:

- Prepares SSH users and folders
- Sets up all necessary files for NGINX, PHP, MySQL, etc.

### `bin/install.wizard.sh`
An installation wizard that assists in selecting and installing:

- Web servers (Apache / NGINX)
- PHP versions
- Database versions

Additionally, this script installs Docker, Certbot, MC, and all required libraries to run PHP.

### `templates/*`
Contains template files for Docker, NGINX, Let's Encrypt, and other services. These templates are used during the setup processes to ensure consistent configurations.

### `wizard/*`
Houses step-by-step bash files used in the install and domain wizard scripts. These files guide users through the installation and configuration steps, ensuring a smooth setup process.

## Features

- **Easy Configuration**: Step-by-step wizards to configure and install services.
- **Service Installation**: Scripts to install and configure web servers, PHP, databases, Docker, and more.
- **Template Management**: Predefined templates for consistent service setup.
- **Ubuntu Compatibility**: Designed for Ubuntu 20.04 and 22.04.
- **Magento Support**: Optimized for setting up Magento open-source projects and environments.

## Usage

1. **Service Installation**:
   Use the Installation Wizard to select and install web servers, PHP, and databases.
   ```sh
   bash bin/install.wizard.sh

2. **Domain Configuration**:
   Run the Domain Wizard to set up SSH users, configure folders, and prepare necessary files for your server.
   ```sh
   bash bin/domain.wizard.sh


# License
This project is licensed under the MIT License. See the LICENSE file for details.