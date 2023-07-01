FROM ghcr.io/wangyoucao577/seastar/seastar-dev:latest


# avoid interactive during apt install
ARG DEBIAN_FRONTEND=noninteractive

# Install basic packages
RUN apt-get update && apt-get install --no-install-recommends -y \
  zsh openssh-server \
  python3-pip \
  less vim curl wget rsync git git-lfs jq zip unzip \
  tmux tree stow \
  iperf3 net-tools iputils-ping mtr dnsutils iproute2 \
  sudo psmisc file htop atop sysstat strace elfutils pax-utils libc-bin \
  pciutils dmidecode \
  lsb-release software-properties-common gnupg2 autoconf \
  locales-all ca-certificates \
  xauth x11-apps \
  && rm -rf /var/lib/apt/lists/*

# install docker for docker-in-docker
# use volume to leverage overlay2 in dind docker, see more in https://stackoverflow.com/questions/67953609/overlay2-driver-not-supported
RUN curl -sSL https://get.docker.com/ | sh
VOLUME /var/lib/docker

# install oh-my-zsh, then prepare dotfiles
COPY .shrc_local /root/
RUN chsh -s $(which zsh) && \
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
  echo '[[ -f ~/.shrc_local ]] && . ~/.shrc_local' >> ~/.zshrc && \
  echo 'PROMPT="%F{cyan}%n@%F{cyan}%m ${PROMPT}"' >> ~/.zshrc && \
  echo 'DISABLE_AUTO_TITLE="true"' >> ~/.zshrc && \
  echo 'title "%m"' >> ~/.zshrc
RUN cd /root/ && \
  git clone https://github.com/wangyoucao577/dotfiles.git .dotfiles && \
  cd .dotfiles && \
  rm -f .bashrc && \
  stow -v .

# prepare for sshd
# RUN echo 'root:root' | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
  echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
  echo "X11UseLocalhost no" >> /etc/ssh/sshd_config 
RUN service ssh start

# allow root to run sudo
RUN usermod -a -G sudo root

# set workspace
WORKDIR /root/workspace

# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment

# lanuch via ssh by default
ENTRYPOINT ["/usr/sbin/sshd", "-D"]


LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/containers



