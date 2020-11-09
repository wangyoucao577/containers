
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

# set workspace
WORKDIR /root/workspace

# install go
RUN wget --progress=dot:mega --no-check-certificate https://golang.org/dl/go1.15.3.linux-amd64.tar.gz && \
  tar -zxf go1.15.3.linux-amd64.tar.gz && \
  mv go /usr/local/ && \
  rm -f go1.15.3.linux-amd64.tar.gz && \
  mkdir -p go/bin /go/src go/pkg

# set env
ENV GO_HOME=/usr/local/go
ENV PATH=${GO_HOME}/bin/:$PATH
ENV GOPATH=/root/workspace/go


# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment


LABEL maintainer="wangyoucao577@gmail.com"

