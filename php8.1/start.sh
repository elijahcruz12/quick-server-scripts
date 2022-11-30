# This script allows you to setup a server with PHP 8.1, Nginx, MySQL, and Redis. Works on Ubuntu 22.04.

# Get the user's name
username=$(whoami)

clear
echo "Welcome to the PHP 8.1 server setup script!"
echo "This script will install PHP 8.1, Nginx, MySQL, and Redis."
echo "It will also configure Nginx to use PHP 8.1."
echo "This script will also create a new user for MySQL."

echo "Script by @elijahcruz12"

# Sleep for 5 seconds
sleep 5

# Ask the user if they want to continue
echo "Do you want to continue? (y/n)"
read -r continue

if [ "$continue" = "n" ]; then
    echo "Exiting..."
    exit 1
fi

# Update the system
echo "Updating the system..."
sudo apt update
echo "Upgrading the system..."
sudo apt upgrade -y

# Make sure curl is installed
echo "Installing curl..."
sudo apt install curl -y

# Make sure zip unzip, and git are installed
echo "Installing zip, unzip, and git..."
sudo apt install zip unzip git -y

# Install Nala
echo "Installing Nala..."
sudo apt install nala -y
sudo nala fetch

# Install Nginx
echo "Installing Nginx..."
echo "Adding Nginx repository..."
sudo add-apt-repository ppa:ondrej/nginx-mainline -y
sudo apt update
echo "Installing Nginx..."
sudo apt install nginx -y

# Add the user to the www-data group
echo "Adding the user to the www-data group..."
sudo usermod -a -G www-data $username

# Install PHP 8.1
echo "Installing PHP 8.1..."
echo "Adding PHP 8.1 repository..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
echo "Installing PHP 8.1..."
sudo apt install php8.1-cli php8.1-fpm -y

# Create seperate apt install commands for each PHP module: php8.1-xml php8.1-imagick php8.1-curl php8.1-sqlite3 php8.1-gd php8.1-bcmath php8.1-yaml php8.1-zip php8.1-bz2 php8.1-mbstring php8.1-mysql php8.1-pdo php8.1-redis php8.1-curl php8.1-dom php8.1-memcached php8.1-intl
echo "Installing PHP 8.1 modules..."
sudo apt install php8.1-xml -y
sudo apt install php8.1-imagick -y
sudo apt install php8.1-curl -y
sudo apt install php8.1-sqlite3 -y
sudo apt install php8.1-gd -y
sudo apt install php8.1-bcmath -y
sudo apt install php8.1-yaml -y
sudo apt install php8.1-zip -y
sudo apt install php8.1-bz2 -y
sudo apt install php8.1-mbstring -y
sudo apt install php8.1-mysql -y
sudo apt install php8.1-pdo -y
sudo apt install php8.1-redis -y
sudo apt install php8.1-curl -y
sudo apt install php8.1-dom -y
sudo apt install php8.1-memcached -y
sudo apt install php8.1-intl -y

# Ask the user if they want to install MySQL
read -p "Do you want to install MySQL? (y/n): " mysql

# Install MySQL
if [ "$mysql" = "y" ]; then
    echo "Installing MySQL..."
    echo "Adding MySQL repository..."
    sudo apt install mysql-server -y
    sudo mysql_secure_installation

    # Ask the user if they want to install phpMyAdmin
    read -p "Do you want to install phpMyAdmin? (y/n): " phpmyadmin
    
fi

# Ask the user if they want to install Redis
read -p "Do you want to install Redis? (y/n): " redis

# Install Redis if the user wants to
if [ "$redis" = "y" ]; then
    echo "Installing Redis..."
    sudo apt install redis-server -y
fi

# Install Composer
echo "Installing Composer..."
cd ~
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
echo "Composer hash:"
echo $HASH
php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
echo "Composer version:"
composer --version

# Ask the user if they want to install Supervisor
read -p "Do you want to install Supervisor? (y/n): " supervisor

# Install Supervisor if the user wants to
if [ "$supervisor" = "y" ]; then
    echo "Installing Supervisor..."
    sudo apt install supervisor -y
fi

# Ask the user if they want to install Node.js
read -p "Do you want to install Node.js? (y/n): " node

# Install Node.js if the user wants to
if [ "$node" = "y" ]; then
    echo "Installing Node.js..."
    # Ask the user which version of Node.js they want to install
    read -p "Enter the version of Node.js you want to install: " node_version
    echo "Installing Node.js $node_version..."
    curl -sL https://deb.nodesource.com/setup_$node_version.x | sudo -E bash -
    sudo apt install nodejs -y
    
    # Update npm
    echo "Updating npm..."
    sudo npm install -g npm

    # Ask the user if they want to install Yarn
    read -p "Do you want to install Yarn? (y/n): " yarn

    # Install Yarn if the user wants to
    if [ "$yarn" = "y" ]; then
        echo "Installing Yarn..."
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
        sudo apt update
        sudo apt install yarn -y
    fi
fi

echo "Done!"