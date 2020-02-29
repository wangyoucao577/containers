
FROM telenavmap/osrm-backend-dev:latest


# install extra tools
RUN apt-get install -y \
  openssh-server \
  gdb \
  locales-all

# prepare for sshd
RUN mkdir -p /root/.ssh
COPY jay_easy_rsa.pub /root/.ssh/
RUN cat /root/.ssh/jay_easy_rsa.pub >> /root/.ssh/authorized_keys && \
  chmod 600 /root/.ssh/authorized_keys && \
  chmod 700 /root/.ssh/ && \
  chmod 755 /root/
RUN service ssh start

COPY .tmux.conf /root/
COPY .vimrc /root/
COPY .bashrc /root/

# latest vscode extension
RUN cd /workspace && \
  wget --progress=dot:mega https://github.com/microsoft/vscode-cpptools/releases/download/0.26.3/cpptools-linux.vsix

# prepare osrm-backend dev env
COPY vscode/ /workspace/vscode/ 
RUN cd /workspace && \
  git clone https://github.com/Telenav/osrm-backend.git && \
  cd osrm-backend && \
  mkdir -p build/debug build/release && \
  cp -r /workspace/vscode .vscode

# sample osm pbf
RUN cd /workspace && \
  mkdir -p osrm-mapdata-nevada && \
  cd osrm-mapdata-nevada && \
  wget --progress=dot:mega https://download.geofabrik.de/north-america/us/nevada-latest.osm.pbf 


ENTRYPOINT ["/usr/sbin/sshd", "-D"]

# labels
LABEL maintainer="wangyoucao577@gmail.com"