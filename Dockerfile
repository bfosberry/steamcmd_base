# SteamCmd Base
#
# VERSION 0.1

FROM bfosberry/gamekick_base
MAINTAINER bfosberry

# install prerequisites
RUN apt-get -y install lib32gcc1 lib32z1 lib32ncurses5 lib32bz2-1.0
# set up env
RUN mkdir -p /opt/steam
RUN mkdir -p /opt/server

ENV USERNAME steam
RUN adduser --gecos "" $USERNAME
RUN chown steam.steam /opt/steam
RUN chown steam.steam /opt/server
USER steam
ENV HOME /home/$USERNAME
ENV STEAMDIR /opt/steam
ENV SERVERDIR /opt/server
RUN mkdir -p $STEAMDIR

ENV PATH /opt/scripts/:/opt/server/scripts/:$PATH

# download steamcmd
RUN wget -O - http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $STEAMDIR -xvz

# install steamcmd
RUN $STEAMDIR/steamcmd.sh +quit
RUN mkdir -p $HOME/.steam/sdk32
RUN ln -s $STEAMDIR/linux32/steamclient.so /$HOME/.steam/sdk32/steamclient.so

ADD ./scripts/init.d.sh /etc/init.d/game_server

ONBUILD ADD ./scripts /opt/server/scripts
ONBUILD RUN $STEAMDIR/steamcmd.sh +runscript /opt/server/scripts/update_script
