
FROM telenavmap/osrm-backend-dev:latest


# install extra tools
RUN apt-get update && apt-get install -y \
  openssh-server \
  gdb \
  tmux \
  locales-all \
  iperf3 \
  net-tools \
  iputils-ping \
  dnsutils \
  htop \
  zip

# prepare for sshd
COPY jay_easy_rsa.pub /root/.ssh/
RUN cat /root/.ssh/jay_easy_rsa.pub >> /root/.ssh/authorized_keys && \
  chmod 600 /root/.ssh/authorized_keys && \
  chmod 700 /root/.ssh/ && \
  chmod 755 /root/
RUN service ssh start

COPY .tmux.conf /root/
COPY .vimrc /root/
COPY .bashrc /root/

RUN git config --global core.editor vim && \
  git config --global credential.helper 'cache --timeout 3600'

# latest vscode extension
RUN cd /workspace && \
  wget --progress=dot:mega https://github.com/microsoft/vscode-cpptools/releases/download/0.27.0/cpptools-linux.vsix

# prepare osrm-backend dev env
COPY vscode/ /workspace/vscode/ 
RUN cd /workspace && \
  git clone https://github.com/Telenav/osrm-backend.git && \
  cd osrm-backend && \
  mkdir -p build/debug build/release && \
  cp -r /workspace/vscode/cpp .vscode && \
  cp -r /workspace/vscode/go integration/.vscode

# sample osm pbf
RUN cd /workspace && \
  mkdir -p osrm-mapdata-nevada && \
  cd osrm-mapdata-nevada && \
  wget --progress=dot:mega https://download.geofabrik.de/north-america/us/nevada-latest.osm.pbf 


ENTRYPOINT ["/usr/sbin/sshd", "-D"]

# labels
LABEL maintainer="wangyoucao577@gmail.com"

