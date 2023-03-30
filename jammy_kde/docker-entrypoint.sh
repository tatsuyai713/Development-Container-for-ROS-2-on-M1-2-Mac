#!/bin/bash -e

USER_ID=$(id -u)
GROUP_ID=$(id -g)
USER=${USER}
GROUP=${GROUP}
PASSWD=${PASSWD}
# Add LibreOffice to library path
export LD_LIBRARY_PATH="/usr/lib/libreoffice/program:${LD_LIBRARY_PATH}"

# Start DBus without systemd
sudo /etc/init.d/dbus start

export DISPLAY=":0"

# Set login user name
USER=$(whoami)
echo "USER: $USER"

# Set login password
echo "PASSWD: $PASSWD"
echo ${USER}:${PASSWD} | sudo chpasswd

# SSH start
sudo service ssh start

# Pulseaudio
pulseaudio --start

# Choose startplasma-x11 or startkde for KDE startup
if [ -x "$(command -v startplasma-x11)" ]; then export KDE_START="startplasma-x11"; else export KDE_START="startkde"; fi

[[ ! -e ${HOME}/.xsession ]] && \
    cp /etc/skel/.xsession ${HOME}/.xsession
[[ ! -e /etc/xrdp/rsakeys.ini ]] && \
    sudo -u xrdp -g xrdp xrdp-keygen xrdp /etc/xrdp/rsakeys.ini > /dev/null 2>&1

dbus-launch fcitx &
sudo /usr/bin/supervisord -c /etc/supervisor/xrdp.conf


echo "#############################"
# exec "$@"
