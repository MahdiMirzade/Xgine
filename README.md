# Xgine

> A stupid pet project for learning bash scripting and webservers, don't expect much.

Xgine is going to be an Nginx control panel.

**As I said "IT'S GOING TO BE", now it's currently under developement, SO DON'T EVER USE THIS UNTIL 1.0 RELEASE.**

## Installation
You can use these methods to install Xgine:
- [Auto Install](#auto-install)
- [Manual Install](#manual-install)

### Auto Install
One-line install command:
```
$ curl -L https://git.io/J3Jbz | bash
```

### Manual Install
#### Step 1: Check requirements
This project is going to be available in:
- CentOS 7
- CentOS 8
- Arch Linux (My PC is running arch so that makes sense right?)

#### Step 2: Continue installation based on your OS
Why is there different ways to push this off? Mainly because different distros have different ways of package installation, you'll see by just looking at the instructions.

**CentOS 7: Yum Package Manager**
```
$ yum update
$ yum install epel-release 
$ yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
$ yum install yum-utils
$ yum-config-manager --enable remi-php72 > /dev/null &
$ yum install nginx mariadb-server php php-fpm php-opcache php-cli php-gd php-curl php-mysqli phpmyadmin
```

**CentOS 8: Dnf Package Manager**
```
$ dnf update
$ dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
$ dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
$ dnf module enable php:remi-7.2
$ dnf install nginx mariadb mariadb-server php php-fpm php-opcache php-cli php-gd php-curl php-mysqli phpmyadmin
```

**Arch Linux: Pacman Package Manager**
```
$ pacman -Syu nginx mysql mariadb php php-fpm phpmyadmin
$ mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
```

#### Step 3: Install Xgine on your system
> Going to be something great

#### Step 4: Configure your softwares using Xgine
> Going to be something great

#### Step 5: You're Done
Now that you've finished you can continue after a little rest.<br/>
I highly suggest you to take a moment and star this project It's so fun to do :)

Use Xgine the way it's intended:
[Wiki - Soon](#)

## Donate
<a href="https://raw.githubusercontent.com/mahdymirzade/mahdymirzade/main/assets/dotfiles/heart.gif"><img src="https://raw.githubusercontent.com/mahdymirzade/mahdymirzade/main/assets/dotfiles/lq/heart.gif" alt="Donation Gif" width="200" height="193" align="right"></a>
I put some time on this project and I really don't think it has any values but I would love some cryptocurrencies:
- **BTC:** `1H5YUVVif9u9JNBVaboCwsBvHAoDeAW5yc`
- **ETH:** `0x05A11A118eb3BDbD015c2fdd3F843dBe422C2955`
- **LTC:** `LiZRqXUrQYjs8TapBEpEngiSiZMvViaPhi`
- **ZEC:** `t1NRoc1a6nXxZT1c1dDCUaMTGGRcpfCBcXy`

Made with <3 by **Mahdy Mirzade**

Yell at me: [me@mahdy.fun](mailto:me@mahdy.fun)
