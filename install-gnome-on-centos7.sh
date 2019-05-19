#!/bin/sh

# using this function to log all action for debugging
# purposes
function commit {
        local log=$PWD/install-gnome-on-centos7.log
        printf "running command: '%s'\n" "$*" 2>&1 >> $log > /dev/null

        # check if user is root, if not then use sudo
        if [ $(id -u) -eq 0 ] ; then
                $* 2>&1 | tee -a $log
        else
                printf "user is not root. using sudo.\n" \
                        2>&1 |tee -a $log

                sudo $* 2>&1 | tee -a $log
        fi
}

# install needed packages
commit yum -y install \
        xorg-x11-drivers xorg-x11-drv-vesa xorg-x11-drv-vmware xorg-x11-drv-fbdev \
        xorg-x11-server-Xorg xorg-x11-xinit-session \
        xorg-x11-utils xorg-x11-xauth xorg-x11-fonts-75dpi \
        xorg-x11-fonts-100dpi xorg-x11-fonts-misc \
        gnome-classic-session gnome-terminal \
        nautilus-open-terminal control-center \
        dejavu-fonts-common dejavu-lgc-sans-fonts \
        dejavu-lgc-sans-mono-fonts liberation-mono-fonts \
        liberation-sans-fonts \
        firefox

# set graphical environment as default target
commit systemctl set-default graphical.target

# start graphical environment
commit systemctl start graphical.target

# EOF
