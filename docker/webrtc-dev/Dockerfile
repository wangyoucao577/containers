
FROM debian:bullseye-slim

# Install basic packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  openssh-server \
  python3-pip \
  gdb \
  tmux \
  curl wget \
  vim \
  git git-lfs \
  zip unzip \
  tree \
  stow \
  iperf3 net-tools iputils-ping mtr dnsutils \
  htop atop sysstat strace \
  jq \
  lsb-release \
  software-properties-common \
  gnupg2 \
  sudo \
  file \
  locales-all \
  pkg-config \
  ca-certificates \
  xauth \
  x11-apps \
  && rm -rf /var/lib/apt/lists/*

# install android ndk 21
RUN wget --progress=dot:mega https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip && \
  unzip android-ndk-r21e-linux-x86_64.zip && \
  rm android-ndk-r21e-linux-x86_64.zip && \
  # refer to https://github.com/actions/virtual-environments/blob/main/images/linux/Ubuntu2004-README.md#environment-variables-3
  #   but change ANDROID_SDK_ROOT path to /root/Android/Sdk for android studio auto-sync
  # env ANDROID_SDK_ROOT, ANDROID_NDK_HOME will be set in .bashrc_local
  mkdir -p /root/Android/Sdk/ndk/ && \
  mv android-ndk-r21e /root/Android/Sdk/ndk/ && \
  cd /root/Android/Sdk/ && \
  ln -s $(pwd)/ndk/android-ndk-r21e $(pwd)/ndk/21.4.7075529 && \
  ln -s $(pwd)/ndk/21.4.7075529 $(pwd)/ndk-bundle

# install clang
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" && \
  update-alternatives --install /usr/bin/clang clang /usr/bin/clang-13 100 && \
  update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-13 100 && \
  update-alternatives --install /usr/bin/clang-cpp clang-cpp /usr/bin/clang-cpp-13 100 && \
  update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 && \
  update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100 && \
  rm -rf /var/lib/apt/lists/* && \
  clang --version

# for jre/jdk installation
RUN mkdir -p /usr/share/man/man1

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
# RUN echo 'root:root' | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
  echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
  echo "X11UseLocalhost no" >> /etc/ssh/sshd_config && \
  echo "Port 13191" >> /etc/ssh/sshd_config
RUN service ssh start

# allow root to run sudo
RUN usermod -a -G sudo root

# install additonal packages for building or application depedencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --no-install-recommends -y \
  libz-dev \
  libpulse-dev \
  libasound2-dev \
  libssl-dev \
  yasm \
  ffmpeg \
  coturn \
  && rm -rf /var/lib/apt/lists/*

# set workspace
WORKDIR /root/workspace

# install conda for python, https://docs.anaconda.com/anaconda/install/silent-mode/
RUN wget --progress=dot:mega https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
  bash ~/miniconda.sh -b -p $HOME/miniconda && \
  rm -f ~/miniconda.sh && \
  ~/miniconda/bin/conda init

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

# install cmake
RUN wget --progress=dot:mega https://github.com/Kitware/CMake/releases/download/v3.22.0/cmake-3.22.0-linux-x86_64.tar.gz && \
  tar -zxf cmake-3.22.0-linux-x86_64.tar.gz && \
  mv cmake-3.22.0-linux-x86_64 /usr/local/ && \
  rm cmake-3.22.0-linux-x86_64.tar.gz && \
  cd /usr/local/cmake-3.22.0-linux-x86_64/ && \
  stow -v --ignore=man . && \
  cmake --version

# install websocat
RUN wget --progress=dot:mega https://github.com/vi/websocat/releases/download/v1.8.0/websocat_amd64-linux-static && \
  chmod +x websocat_amd64-linux-static && \
  mv websocat_amd64-linux-static /usr/local/bin/ && \
  ln -s /usr/local/bin/websocat_amd64-linux-static /usr/local/bin/websocat && \
  websocat --version

# install go
RUN wget --progress=dot:mega --no-check-certificate https://go.dev/dl/$(curl https://go.dev/VERSION?m=text).linux-amd64.tar.gz -O go.linux-amd64.tar.gz && \
  tar -zxf go.linux-amd64.tar.gz && \
  mv go /usr/local/ && \
  rm -f go.linux-amd64.tar.gz && \
  mkdir -p go/bin /go/src go/pkg

# vscode configs and latest extensions
RUN mkdir -p vscode && cd vscode && \
  wget --progress=dot:mega --no-check-certificate https://github.com/microsoft/vscode-cpptools/releases/download/1.7.1/cpptools-linux.vsix && \
  wget --progress=dot:mega --no-check-certificate https://github.com/golang/vscode-go/releases/download/v0.29.0/go-0.29.0.vsix

# install depot_tools: https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html#_setting_up
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git


# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment

# lanuch via ssh by default
ENTRYPOINT ["/usr/sbin/sshd", "-D"]


LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/containers



