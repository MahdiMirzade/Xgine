#!/bin/bash
#
#   __  __       _         _         __  __ _                   _
#  |  \/  | __ _| |__   __| |_   _  |  \/  (_)_ __ ______ _  __| | ___
#  | |\/| |/ _` | '_ \ / _` | | | | | |\/| | | '__|_  / _` |/ _` |/ _ \
#  | |  | | (_| | | | | (_| | |_| | | |  | | | |   / / (_| | (_| |  __/
#  |_|  |_|\__,_|_| |_|\__,_|\__, | |_|  |_|_|_|  /___\__,_|\__,_|\___|
#                            |___/
#
# This file is a part of `github.com/mahdymirzade/xgine`.
#
#
# Coloring
expand_bg="\e[K"
red_bg="\e[0;101m${expand_bg}"
green_bg="\e[0;102m${expand_bg}"
blue_bg="\e[0;104m${expand_bg}"
red="\e[0;91m"
green="\e[0;92m"
blue="\e[0;94m"
white="\e[0;97m"
bold="\e[1m"
uline="\e[4m"
reset="\e[0m"

# Handle logger
function logger () {
    format=$1
    if [[ $format == "red" || $format == "blue" || $format == "green" ]]; then
        bgcolor="${format}_bg"
    else
        bgcolor="expand_bg"
        if [[ $format == "" || $format == "null" || $format == "none" ]]; then
            format="reset"
        fi
    fi
    echo -en "${reset}${!bgcolor}${bold}XGINE${reset}${expand_bg} "
    echo -en "${reset}${!format}"
    addon="-e"
    if [[ $3 == "nobreak" ]]; then
        addon="-en"
    elif [[ $3 == "bold" ]]; then
        prefixx="${bold}"
    elif [[ $3 == "uline" ]]; then
        prefixx="${uline}"
    else
        prefixx=""
    fi
    echo $addon "${prefixx}${2}"
    echo -en "${reset}"
}
function separator () {
    logger "" "." "nobreak"
    for ((i = 0 ; i < 54 ; i++)); do
        echo -n "."
    done
    echo "."
}

# Ctrl-c & Ctrl-z handler
function ctrlc () {
    logger "" ""
    logger "red" "You have done a [Ctrl-C], performing clean up..."
    killall -s KILL -q yum dnf pacman > /dev/null &
    logger "red" "Exiting Installer..."
    exit 2
}
trap "ctrlc" 2 
trap "" TSTP

# Verify privileges
if [[ $EUID -ne 0 ]]; then
    logger "red" "This script can't run without enough privileges."
    logger "red" "Please run ${reset}${green}Xgine${reset}${red} as root user."
    exit
fi

# Introduction
function helloworld () {
    logger "green" "Xgine is a control panel for Nginx: (LEMP)"
    logger "green" "https://github.com/mahdymirzade/xgine"
    logger "green" ""
    logger "green" "__  __     _"
    logger "green" "\ \/ /__ _(_)_ __   ___"
    logger "green" " \  // _\` | | '_ \ / _ \\"
    logger "green" " /  \ (_| | | | | |  __/"
    logger "green" "/_/\_\__, |_|_| |_|\___|"
    logger "green" "     |___/"
    logger "green" ""
    XGINE_LINUX_DISTRO=$(cat /etc/*-release | awk '/^NAME=".*"$/' | cut -d '"' -f 2)
    XGINE_LINUX_DISTRO_VERSION=$(cat /etc/*-release | awk '/^VERSION_ID=".*"$/' | cut -d '"' -f 2)
    XGINE_TOTAL_MEMORY=$((($(awk '/MemTotal/ {print $2}' /proc/meminfo)/1024)))
    logger "blue" "Distro: $XGINE_LINUX_DISTRO" "bold"
    if [[ -n $XGINE_LINUX_DISTRO_VERSION ]]; then
        logger "blue" "Release: $XGINE_LINUX_DISTRO_VERSION" "bold"
    fi
    logger "blue" "Total Ram: $XGINE_TOTAL_MEMORY MB" "bold"
}

# Check OS and requirements
function requirements () {
    logger "bold" "Starting installer in 10 seconds... (Exit with [Ctrl+C])"
    logger "" "......" "nobreak"
    for ((i = 0 ; i < 10 ; i++)); do
        sleep 1
        echo -n "....."
    done
    echo ""
    if [[ $XGINE_LINUX_DISTRO == "CentOS Linux" ]]; then
        VER=$XGINE_LINUX_DISTRO_VERSION
        if [[ $VER -eq 7 ]]; then
            yumInstall
        elif [[ $VER -eq 8 ]]; then
            dnfInstall
        else
            notSupported
        fi
    elif [[ $XGINE_LINUX_DISTRO == "Arch Linux" ]]; then
        pacmanInstall
    else
        notSupported
    fi
    services=('mariadb' 'nginx' 'php-fpm')
    for i in "${services[@]}"; do
        systemctl enable $i
        systemctl start $i
    done
    #mysql_secure_installation
}

# Package Installer
function yumInstall () {
    logger "blue" "Installing requirements with yum:" "uline"
    yum -q --color=auto -y update
    yum -q --color=auto -y install epel-release 
    yum -q --color=auto -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    yum -q --color=auto -y install yum-utils
    yum-config-manager --enable remi-php72 > /dev/null &
    yum -q --color=auto -y install nginx mariadb-server php php-fpm php-opcache php-cli php-gd php-curl php-mysqli phpmyadmin
    logger "bold" "Yum Yum :P"
}
function dnfInstall () {
    logger "blue" "Installing requirements with dnf:" "uline"
    dnf -q --color=auto -y update
    dnf -q --color=auto -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    dnf -q --color=auto -y install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
    dnf module enable php:remi-7.2
    dnf -q --color=auto -y install nginx mariadb mariadb-server php php-fpm php-opcache php-cli php-gd php-curl php-mysqli phpmyadmin
    logger "bold" "Denf Donf ?"
}
function pacmanInstall () {
    logger "blue" "Installing requirements with pacman:" "uline"
    pacman -Syu nginx mysql mariadb php php-fpm phpmyadmin -q --needed --noconfirm --color=auto
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    logger "bold" "Pac Pac :D"
}
function notIupported () {
    logger "red" "Sorry! $XGINE_LINUX_DISTRO $XGINE_LINUX_DISTRO_VERSION IS NOT SUPPORTED."
    logger "red" "Exiting the installer..."
    exit 2
}

# Backup old config
function backup () {
    logger "blue" "Taking old configuration backup:" "uline"
    startpath=$(pwd)
    backuptime=$(date +'%F_%H-%M-%S')
    pathtobackups=/opt/xgine/oldconfbackups/$backuptime
    mkdir -p $pathtobackups
    cd /etc/nginx
    tar -czvf nginx.tar.gz *
    mv nginx.tar.gz $pathtobackups
    if [[ -e /etc/php-fpm.d/www.conf ]]; then
        cat /etc/php-fpm.d/www.conf > php-fpm.www.conf
    fi
    cd $startpath
}

# Outro
function endworld () {
    logger "green" "Done :)" "bold"
}

# Main installation
function main () {
    clear
    helloworld
    separator
    requirements
    separator
    backup
    separator
    endworld
}

main
