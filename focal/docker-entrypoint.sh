#!/bin/bash -e

USER_ID=$(id -u)
GROUP_ID=$(id -g)
USER=${USER}
GROUP=${GROUP}
PASSWD=${PASSWD}

if (( $# == 0 )); then
    # Set login user name
    USER=$(whoami)
    echo "USER: $USER"

    # Set login password
    echo "PASSWD: $PASSWD"
    echo ${USER}:${PASSWD} | sudo chpasswd

    [[ ! -e ${HOME}/.xsession ]] && \
        cp /etc/skel/.xsession ${HOME}/.xsession
    [[ ! -e /etc/xrdp/rsakeys.ini ]] && \
        sudo -u xrdp -g xrdp xrdp-keygen xrdp /etc/xrdp/rsakeys.ini > /dev/null 2>&1

    set -- /usr/bin/supervisord -c /etc/supervisor/xrdp.conf
    if [[ $USER_ID != "0" ]]; then
        [[ ! -e /usr/local/bin/_gosu ]] && \
            sudo install -g $GROUP_ID -m 4750 $(which gosu) /usr/local/bin/_gosu
        set -- /usr/local/bin/_gosu root "$@"
    fi
fi

echo "#############################"
exec "$@"
