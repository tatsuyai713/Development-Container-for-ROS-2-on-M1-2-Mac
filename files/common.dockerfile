FROM ubuntu:24.04

RUN echo 'path-include=/usr/share/locale/ja/LC_MESSAGES/*.mo' > /etc/dpkg/dpkg.cfg.d/includes \
    && apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
    sudo \
    build-essential \
    curl \
    less \
    apt-utils \
    tzdata \
    git \
    tmux \
    bash-completion \
    command-not-found \
    libglib2.0-0 \
    vim \
    emacs \
    ssh \
    rsync \
    python3-pip \
    sed \
    ca-certificates \
    wget \
    lsb-release \
    gnupg

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
    software-properties-common \
    alsa-base \
    alsa-utils \
    apt-transport-https \
    apt-utils \
    build-essential \
    ca-certificates \
    cups-filters \
    cups-common \
    cups-pdf \
    curl \
    file \
    wget \
    bzip2 \
    gzip \
    p7zip-full \
    xz-utils \
    zip \
    unzip \
    zstd \
    gcc \
    git \
    jq \
    make \
    python3 \
    python3-cups \
    python3-numpy \
    nano \
    vim \
    htop \
    fonts-dejavu-core \
    fonts-freefont-ttf \
    fonts-noto \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    fonts-noto-color-emoji \
    fonts-noto-hinted \
    fonts-noto-mono \
    fonts-opensymbol \
    fonts-symbola \
    fonts-ubuntu \
    libpulse0 \
    pulseaudio \
    supervisor \
    net-tools \
    libglvnd-dev \
    libgl1-mesa-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libgles2 \
    libglu1 \
    libsm6 \
    vainfo \
    vdpauinfo \
    pkg-config \
    mesa-utils \
    mesa-utils-extra \
    va-driver-all \
    xserver-xorg-input-all \
    xserver-xorg-video-all \
    mesa-vulkan-drivers \
    libvulkan-dev \
    libxau6 \
    libxdmcp6 \
    libxcb1 \
    libxext6 \
    libx11-6 \
    libxv1 \
    libxtst6 \
    xdg-utils \
    dbus-x11 \
    libdbus-c++-1-0v5 \
    xkb-data \
    x11-xkb-utils \
    x11-xserver-utils \
    x11-utils \
    x11-apps \
    xauth \
    xbitmaps \
    xinit \
    xfonts-base \
    libxrandr-dev \
    vulkan-tools && \
    rm -rf /var/lib/apt/lists/*

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
    kde-plasma-desktop \
    kwin-addons \
    kwin-x11 \
    kdeadmin \
    akregator \
    ark \
    baloo-kf5 \
    breeze-cursor-theme \
    breeze-icon-theme \
    debconf-kde-helper \
    colord-kde \
    desktop-file-utils \
    filelight \
    gwenview \
    hspell \
    kaddressbook \
    kaffeine \
    kate \
    kcalc \
    kcharselect \
    kdeconnect \
    kde-spectacle \
    kde-config-screenlocker \
    kde-config-updates \
    kdf \
    kget \
    kgpg \
    khelpcenter \
    khotkeys \
    kimageformat-plugins \
    kinfocenter \
    kio-extras \
    kleopatra \
    kmail \
    kmenuedit \
    knotes \
    kontact \
    kopete \
    korganizer \
    krdc \
    ktimer \
    kwalletmanager \
    librsvg2-common \
    okular \
    okular-extra-backends \
    plasma-dataengines-addons \
    plasma-discover \
    plasma-runners-addons \
    plasma-wallpapers-addons \
    plasma-widgets-addons \
    plasma-workspace-wallpapers \
    qtvirtualkeyboard-plugin \
    sonnet-plugins \
    sweeper \
    systemsettings \
    xdg-desktop-portal-kde \
    kubuntu-restricted-extras \
    kubuntu-wallpapers \
    kubuntu-desktop \
    pavucontrol-qt \
    transmission-qt && \
    apt install --install-recommends -y \
    libreoffice \
    libreoffice-style-breeze && \
    rm -rf /var/lib/apt/lists/*

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
    xrdp \
    supervisor \
    htop

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
    ubuntu-wallpapers \
    && apt clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* 



ENV XDG_CURRENT_DESKTOP KDE
ENV KWIN_COMPOSE N
# Use sudoedit to change protected files instead of using sudo on kate
ENV SUDO_EDITOR kate


RUN add-apt-repository ppa:mozillateam/ppa

RUN { \
    echo 'Package: firefox*'; \
    echo 'Pin: release o=LP-PPA-mozillateam'; \
    echo 'Pin-Priority: 1001'; \
    echo ' '; \
    echo 'Package: firefox*'; \
    echo 'Pin: release o=Ubuntu*'; \
    echo 'Pin-Priority: -1'; \
    } > /etc/apt/preferences.d/99mozilla-firefox

RUN apt -y update \
    && apt install -y firefox

# install ROS2 Jazzy
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt update && apt install -y --no-install-recommends \
    ros-jazzy-desktop-full \
    ros-dev-tools \
    && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# install colcon and rosdep
RUN apt update && apt install -y --no-install-recommends \
    python3-colcon-common-extensions \
    python3-rosdep \
    && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# install clinfo
RUN apt update && apt install -y --no-install-recommends \
    clinfo \
    && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "export XDG_RUNTIME_DIR=/run/user/$(id -u)" >> /etc/profile

# Pulseaudio
RUN apt update && apt install -y libtool libpulse-dev git autoconf pkg-config libssl-dev libpam0g-dev libx11-dev libxfixes-dev libxrandr-dev nasm xsltproc flex bison libxml2-dev dpkg-dev libcap-dev meson ninja-build libsndfile1-dev libtdb-dev check doxygen libxml-parser-perl libxtst-dev gettext

RUN git clone --recursive https://github.com/pulseaudio/pulseaudio.git && \
    cd pulseaudio && \
    git checkout tags/v16.1 -b v16.1 && \
    meson build && \
    ninja -C build && \
    cd ../ && \
    git clone --recursive https://github.com/neutrinolabs/pulseaudio-module-xrdp.git && \
    cd pulseaudio-module-xrdp/ && \
    ./bootstrap && ./configure PULSE_DIR=$(pwd)/../pulseaudio && \
    make && make install

# initialize rosdep
RUN rosdep init

# Expose RDP port
EXPOSE 3389

RUN echo "startplasma-x11" > /etc/skel/.xsession \
    && install -o root -g xrdp -m 2775 -d /var/run/xrdp \
    && install -o root -g xrdp -m 3777 -d /var/run/xrdp/sockdir \
    && install -o root -g root -m 0755 -d /var/run/dbus

RUN { \
    echo '#DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };'; \
    echo '#APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };'; \
    echo '#Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";'; \
    } > /etc/apt/apt.conf.d/docker-clean

