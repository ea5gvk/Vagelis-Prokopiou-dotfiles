#!/bin/bash

# Download Viber, Teamviewer, Dropbox, Chrome:
# https://www.viber.com/en/products/linux
# https://www.teamviewer.com/en/download/linux/
# https://www.dropbox.com/install-linux
# https://www.google.com/chrome/browser/desktop/

# Variables:
user='va';
user_home="/home/${user}";
is_initial_install=false;
# is_initial_install=true;

function installPHPUnit()
{
	wget https://phar.phpunit.de/phpunit.phar;
	chmod +x phpunit.phar;
	sudo mv phpunit.phar /usr/local/bin/phpunit;
	echo "PHPUNit installed.";
}

function installTeamviewer()
{
	sudo dpkg --add-architecture i386;\
	sudo apt-get update;\
	sudo dpkg -i --force-depends ./teamviewer*.deb;\
	sudo apt install -y -f;\
	teamviewer --daemon start;\
	sudo rm ./teamviewer*.deb;
}

function installViber()
{
	# See http://drupaland.eu/article/installing-viber-debian-9
	sudo apt install -y libqt5gui5;\
	sudo dpkg -i ./viber.deb;\
	sudo apt --fix-broken install -y;\
	sudo rm ./viber.deb;
}

function installDrush() {
	# Download latest stable release using the code below or browse to github.com/drush-ops/drush/releases.
	php -r "readfile('http://files.drush.org/drush.phar');" > drush
	# Test your install.
	php drush core-status;
	# Make `drush` executable as a command from anywhere. Destination can be anywhere on $PATH.
	sudo chmod +x drush;
	sudo mv drush /usr/local/bin;
	#### ----- Enrich the bash startup file with completion and aliases #####.
	drush init;
}

function installComposer() {
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
	php composer-setup.php
	php -r "unlink('composer-setup.php');"
	mv composer.phar /usr/local/bin/composer;
}

function installDrupalConsole() {
	# php -r "readfile('https://drupalconsole.com/installer');" > drupal.phar;
	curl -O https://drupalconsole.com/installer;
	sudo mv installer /usr/local/bin/drupal;
	sudo chmod +x /usr/local/bin/drupal;
	sudo drupal init;
}

function installNodeJS() {
	curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -;
	sudo apt install -y nodejs;
}

# If it is initlia setup after a fresh install.
if  $is_initial_install; then
	############################################
	# ----- Edit the Debian sources list.
	############################################
	echo "deb http://ftp.gr.debian.org/debian/ stretch main contrib non-free
	# deb-src http://ftp.gr.debian.org/debian/ stretch main contrib non-free

	# deb http://security.debian.org/debian-security stretch/updates main contrib non-free
	# deb-src http://security.debian.org/debian-security stretch/updates main contrib non-free

	# deb http://ftp.gr.debian.org/debian/ stretch-updates main contrib non-free
	# deb-src http://ftp.gr.debian.org/debian/ stretch-updates main contrib non-free" > /etc/apt/sources.list;

	# Add va to sudoers.
	echo 'va	ALL=(ALL:ALL) ALL' >> /etc/sudoers;

	cp /etc/fstab /etc/fstab.bak;
	echo "
	# The following is the disk that has the torrents folder.
	UUID=1A52BBE952BBC7B1   /media/va/local_disk   ntfs    auto,user,exec,rw,suid,noatime,relatime   0   0
	UUID=52AF7EBE182A63E2   /media/va/52AF7EBE182A63E2   ntfs    auto,user,exec,rw,suid,noatime,relatime    0   0" 	>> /etc/fstab;


	############################################
	# ----- Various maintenance tasks.
	############################################
	apt install -y sudo;
	sudo apt update -y;
	sudo apt upgrade -y;
	sudo apt install -y curl;
	sudo apt install -y build-essential;
	sudo apt install -y p7zip-full;
	sudo apt install -y keepass2;
	sudo apt install -y qalculate;
	sudo apt install -y qbittorrent;
	sudo apt install -y apt-transport-https;
	sudo apt install -y vim;
	sudo apt install -y git;

	sudo apt purge -y gnome-games;
	sudo apt purge -y inkscape;
	sudo apt purge -y inkscape;
	sudo apt purge -y evolution;
	sudo apt purge -y seahorse;
	sudo apt purge -y gnome-maps;
	sudo apt purge -y gnome-games;
	sudo apt purge -y gnome-contacts;
	sudo apt purge -y gnome-documents;

	# Google Chrome
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb;
	sudo dpkg -i --force-depends ./google-chrome-stable_current_amd64.deb;
	sudo apt install -y -f;
	sudo rm ./google-chrome-stable_current_amd64.deb;

	# Dropbox
	wget 'https://www.dropbox.com/download?dl=packages/debian/dropbox_2015.10.28_amd64.deb';
	sudo sudo dpkg -i --force-depends ./*dropbox*.deb;\
	sudo apt install -y -f;\
	sudo rm ./*dropbox*.deb;

	# Youtube-dl.
	sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl;
	sudo chmod a+rx /usr/local/bin/youtube-dl;

	# Import and edit pdfs in Libreoffice Draw.
	# sudo apt install -y libreoffice-pdfimport;

	# Nautilus plugin for opening terminals in arbitrary paths.
	# sudo apt install -y nautilus-open-terminal;

	# This is needed for Dropbox.
	sudo apt install -y python-gpgme;

	# This fixes the error when using Sublime for git commits && needed for PhpStorm.
	sudo apt install -y libcanberra-gtk-module;

	# Purges.
	# sudo apt purge -y postgresql*;

	# Drivers for AMD GPU.
	sudo apt install -y firmware-linux-nonfree libgl1-mesa-dri xserver-xorg-video-ati;

	# Create a template txt, for use in right click context.
	touch ${user_home}/Templates/new_file.txt;

	##############################################
	# ----- LAMP on Debian.
	##############################################
	sudo apt -y install apache2;
	sudo apt install -y mariadb-server phpmyadmin;
	sudo apt -y install php7.0-xdebug;
	sudo a2enmod rewrite;
	sudo service apache2 restart;
	sudo apt --fix-broken install;

	# If not able to login to phpmyadmin with root, run the following query:
	# use mysql;
	# update user set password=PASSWORD("NEWPASSWORD") where User='root';
	# GRANT ALL PRIVILEGES ON *.* TO root@localhost IDENTIFIED BY 'root';
	# FLUSH PRIVILEGES;

	# sudo apt remove --purge -y mariadb* php* && sudo apt autoremove -y && sudo apt install -y mariadb-server phpmyadmin;

	if [ ! -f /etc/apache2/apache2.conf.bak ]; then
    	sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak;
		sudo sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf;
	fi

	# For right-click archive extraction.
	# sudo apt install -y nemo-fileroller;

	# For Keepass2 auto-typing.
	command -v > /dev/null 2>&1 xdotool || sudo apt install -y xdotool;

	sudo apt install -y linux-headers-$(uname -r);

	# Tool to manipulate images for the web!!!.
	# sudo apt install -y imagemagick;

	installDrush;
	installComposer;
	installDrupalConsole;
	# installNodeJS;
	# installViber;
	# installTeamviewer;
	installPHPUnit;

# Non initial setup.
else
	installDrush;
	installComposer;
	installDrupalConsole;
	installNodeJS;
	# installViber;
	# installTeamviewer;
	installPHPUnit;

	sudo apt -y update;
	sudo apt -y upgrade;
	# sudo apt -y dist-upgrade;
	sudo apt -y autoremove;
	sudo apt -y check;
	sudo apt -y clean;
	sudo apt -y autoclean;
	sudo apt install -y -f;
	# Check for broken package(s).
	sudo dpkg --audit;

	# Update Composer
	sudo -H composer self-update;

	# Update Drupal Console.
	sudo drupal self-update;

	# Remove the torrent files from Downloads.
	rm ${user_home}/Downloads/*.torrent 2> /dev/null;
fi

# Remove all the caches.
function clear-caches() {
	sudo rm -rf ${user_home}/drush-backups/*;
	sudo rm -rf /root/drush-backups/*;
	sudo find /var/www -iname "*.gz" | grep -v "*.sql.gz" | xargs sudo rm -r;
	sudo find /var/www/html -iname ".com.google.Chrome*" | xargs sudo rm -r;
	sudo find /var/www/ -type f -name '*log' | while read file; do echo -n > "$file"; done;
	sudo find /root /home /var/www "$dir" -ipath "*/.cache/*" -type f -delete;
	sudo find /root /home /var/www "$dir" -ipath "*/cache/*" -type f -delete;
	sudo find /root /home /var/www "$dir" -ipath "*/tmp/*" -type f -delete;
	sudo find /var/www/ -path "*/devel_themer/*" -delete;
	sudo find /root /home -name "*.log"  -delete;
}
# clear-caches;


# http://ubuntuhandbook.org/index.php/2016/05/remove-old-kernels-ubuntu-16-04/
# List all kernels excluding the current booted:
old_kernels=$(dpkg -l | tail -n +6 | grep -E 'linux-image-[0-9]+' | grep -Fv $(uname -r));
if [[ $old_kernels == '' ]]; then
	echo -e "\nThere are no old/unused kernels.\n";
else
	echo -e "\nThere are old kernels that need to be taken care of!!!\n";
fi

# Manipulate services.
sudo service bluetooth stop;
