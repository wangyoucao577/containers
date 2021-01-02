
FROM apolloauto/apollo:dev-x86_64-18.04-20201210_1400

# Install necessary packages for proper system state
RUN apt-get update && apt-get install --no-install-recommends -y \
  openssh-server \
  tmux \
  tree \
  iperf3 \
  net-tools \
  iputils-ping \
  dnsutils \
  htop \
  atop \
  sysstat \
  strace \
  stow \
  jq \
  locales-all \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# install docker for docker-in-docker
RUN curl -sSL https://get.docker.com/ | sh

# prepare dotfiles
RUN cd /root/ && \
  rm -f .bashrc && \
  git clone https://github.com/wangyoucao577/dotfiles.git .dotfiles && \
  cd .dotfiles && \
  stow -v --ignore=.bashrc .

# prepare for sshd
RUN echo 'root:root' | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN service ssh start

# prepare ApolloAuto/apollo scripts
COPY *.sh / 

# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment

# lanuch via ssh by default
ENTRYPOINT ["/usr/sbin/sshd", "-D"]


LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/containers

