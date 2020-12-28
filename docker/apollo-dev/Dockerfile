
FROM ubuntu:focal

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

# prepare for sshd
RUN echo 'root:root' | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
COPY *.pub /root/.ssh/
RUN cat /root/.ssh/jay_easy_rsa.pub >> /root/.ssh/authorized_keys && \
  chmod 600 /root/.ssh/authorized_keys && \
  chmod 700 /root/.ssh/ && \
  chmod 755 /root/
RUN service ssh start

# easy to use
COPY .tmux.conf /root/
COPY .vimrc /root/
RUN git config --global core.editor vim && \
  git config --global http.sslverify false && \
  git config --global credential.helper 'cache --timeout 36000' && \
  git config --global log.decorate auto


# set workspace
WORKDIR /root/workspace

# prepare ApolloAuto/apollo dev env
RUN cd /root/workspace && \
  git clone https://github.com/ApolloAuto/apollo.git

# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment

# lanuch via ssh by default
ENTRYPOINT ["/usr/sbin/sshd", "-D"]


LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/containers

