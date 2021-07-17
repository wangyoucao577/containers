
FROM debian:buster-slim

# Install necessary packages for proper system state
RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  build-essential \
  openssh-server \
  python3-pip \
  cmake \
  gdb \
  tmux \
  curl \
  wget \
  vim \
  git \
  zip \
  unzip \
  tree \
  stow \
  iperf3 \
  net-tools \
  iputils-ping \
  dnsutils \
  htop \
  atop \
  sysstat \
  strace \
  jq \
  locales-all \
  pkg-config \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# install docker for docker-in-docker
RUN curl -sSL https://get.docker.com/ | sh

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

# set workspace
WORKDIR /root/workspace

# install nvm and nodejs
# https://github.com/nvm-sh/nvm#install--update-script
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash && \
  export NVM_DIR="$HOME/.nvm" && \
  # This loads nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  && \
  nvm install node && \
  node --version && \
  npm --version
# Appending below nvm source string to your ~/.bashrc to let nvm/node/npm available 
#  export NVM_DIR="$HOME/.nvm"
#  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# install go
RUN wget --progress=dot:mega --no-check-certificate https://golang.org/dl/go1.16.6.linux-amd64.tar.gz && \
  tar -zxf go1.16.6.linux-amd64.tar.gz && \
  mv go /usr/local/ && \
  rm -f go1.16.6.linux-amd64.tar.gz && \
  mkdir -p go/bin /go/src go/pkg

# vscode configs and latest extensions
RUN mkdir -p vscode && cd vscode && \
  wget --progress=dot:mega --no-check-certificate https://github.com/microsoft/vscode-cpptools/releases/download/1.5.1/cpptools-linux.vsix && \
  wget --progress=dot:mega --no-check-certificate https://github.com/golang/vscode-go/releases/download/v0.26.0/go-0.26.0.vsix


# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment

# lanuch via ssh by default
ENTRYPOINT ["/usr/sbin/sshd", "-D"]


LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/containers

