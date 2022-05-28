# Base image
FROM ubuntu:20.04


# Hello, world!
MAINTAINER sinedynamics@gmail.com


# Global vars
ENV APP /app


# Ports
EXPOSE 9876 9877


# Container env setup
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install locales wget && \
#    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    locale-gen en_US.UTF-8

ENV LANG en_US.utf8
ENV LANGUAGE en_US:en
ENV DEBIAN_FRONTEND noninteractive


# Setup -- SteamCMD
RUN echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
#    add-apt-repository multiverse && \
    dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends \
        ca-certificates \
        steamcmd \
    && \
#    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/games/steamcmd /usr/bin/steamcmd && \
    steamcmd +quit


# Setup -- Wine
ENV WINEARCH win64
RUN apt-get -y update && \
    apt-get -y install \
        wine \
        xvfb \
        x11-utils \
    && \
    wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O /usr/bin/winetricks && \
    chmod +x /usr/bin/winetricks && \
    winetricks sound=disabled
    

    #   xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine VRisingServer.exe -persistentDataPath ./save-data -logFile server.log

    #    mkdir save-data/Settings


# Install -- V Rising
WORKDIR ${APP}
RUN steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir ${APP} \  
    +login anonymous \
    +app_update 1829350 \
    validate \
    +quit

# Here we gooooooooooooo!
CMD xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine VRisingServer.exe -serverName Bloodheim -maxConnectedUsers 10 -persistentDataPath ${APP}/ -saveName server -logFile server.log
