
FROM wangyoucao577/osmium-tool as osmium_builder

FROM telenavmap/osrm-backend-dev:v3


# install extra tools
RUN apt-get update && apt-get install -y \
  openssh-server \
  python3-pip \
  gdb \
  tmux \
  locales-all \
  iperf3 \
  net-tools \
  iputils-ping \
  dnsutils \
  htop \
  atop \
  sysstat \
  strace \
  stow \
  jq

# install docker for docker-in-docker
RUN curl -sSL https://get.docker.com/ | sh

# install elasticdump via nvm/node
RUN export NVM_DIR="$HOME/.nvm" && \
  # This loads nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  && \
  npm install -g elasticdump && \
  npm link elasticdump && \
  elasticdump --version 

# osmium
COPY --from=osmium_builder /osmium /usr/local/stow/osmium/
RUN cd /usr/local/stow/ && stow -v osmium

# prepare dotfiles
RUN cd /root/ && \
  rm -f .bashrc && \
  git clone https://github.com/wangyoucao577/dotfiles.git .dotfiles && \
  cd .dotfiles && \
  stow -v .
COPY .bashrc_local /root/

# prepare for sshd
RUN echo 'root:root' | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN service ssh start

# vscode configs and latest extensions
COPY vscode/ /workspace/vscode/ 
RUN cd /workspace/vscode && \
  wget --progress=dot:mega --no-check-certificate https://github.com/microsoft/vscode-cpptools/releases/download/1.2.1/cpptools-linux.vsix && \
  wget --progress=dot:mega --no-check-certificate https://github.com/golang/vscode-go/releases/download/v0.22.1/go-0.22.1.vsix
RUN mkdir -p /root/.vscode-server/data/Machine && \
  cp /workspace/vscode/settings.json /root/.vscode-server/data/Machine/

# prepare Telenav/osrm-backend dev env
RUN cd /workspace && \
  git clone https://github.com/Telenav/osrm-backend.git && \
  cd osrm-backend && \
  mkdir -p build/debug build/release && \
  cp -r /workspace/vscode/cpp .vscode && \
  cp -r /workspace/vscode/go integration/.vscode

# prepare wangyoucao577/osrm-backend dev env
RUN cd /workspace && \
  git clone https://github.com/wangyoucao577/osrm-backend.git osrm-backend-w && \
  cd osrm-backend-w && \
  mkdir -p build/debug build/release && \
  cp -r /workspace/vscode/cpp .vscode

# sample osm pbf
RUN cd /workspace && \
  mkdir -p osrm-mapdata-nevada && \
  cd osrm-mapdata-nevada && \
  wget --progress=dot:mega --no-check-certificate https://download.geofabrik.de/north-america/us/nevada-latest.osm.pbf 


# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment



WORKDIR /workspace
ENTRYPOINT ["/usr/sbin/sshd", "-D"]

# labels
LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/containers
