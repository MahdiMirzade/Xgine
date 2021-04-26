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
separator="........................................................"

# Handle logger
logger () {
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
separator () {
    logger "" $separator
}

# Ctrl-c & Ctrl-z handler
ctrlc () {
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
helloworld () {
    logger "green" "Xgine is a control panel for Nginx: (LNMP)"
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
requirements () {
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
}

# OS based Package Installer
yumInstall () {
    logger "blue" "Installing requirements with yum:" "uline"
    yum -q --color=auto install epel-release nginx mariadb-server http://rpms.remirepo.net/enterprise/remi-release-7.rpm yum-utils
    yum-config-manager --enable remi-php72 > /dev/null &
    yum -q --color=auto install php-fpm php-opcache php-cli php-gd php-curl php-mysql
    logger "bold" "Yum Yum :P"
}
dnfInstall () {
    logger "bold" "Denf Donf ?"
}
pacmanInstall () {
    logger "blue" "Installing requirements with pacman:" "uline"
    pacman -Syu nginx mysql php php-fpm phpmyadmin -q --needed --noconfirm --color=auto
    logger "bold" "Pac Pac :D"
}
notIupported () {
    logger "red" "Sorry! $XGINE_LINUX_DISTRO $XGINE_LINUX_DISTRO_VERSION IS NOT SUPPORTED."
    logger "red" "Exiting the installer..."
}

# Outro
endworld () {
    logger "green" "Done :)" "bold"
}

# Main installation
main () {
    clear
    helloworld
    separator
    requirements
    separator
    endworld
}

main
