
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

LABEL maintainer="wangyoucao577@gmail.com"

