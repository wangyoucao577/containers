FROM debian:bullseye-slim

# avoid interactive during apt install
ARG DEBIAN_FRONTEND=noninteractive

# Install basic packages
RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential pkg-config automake libtool gperf gdb \
  zsh openssh-server \
  python3-pip \
  vim curl wget rsync git git-lfs jq zip unzip more less \
  tmux tree stow \
  iperf3 net-tools iputils-ping mtr dnsutils netcat iproute2 \
  sudo psmisc file htop atop sysstat strace elfutils pax-utils libc-bin \
  lsb-release software-properties-common gnupg2 autoconf \
  locales-all ca-certificates \
  xauth x11-apps \
  && rm -rf /var/lib/apt/lists/*

# install android ndk 25
RUN wget --progress=dot:mega https://dl.google.com/android/repository/android-ndk-r25b-linux.zip && \
  unzip android-ndk-r25b-linux.zip && \
  rm android-ndk-r25b-linux.zip && \
  # refer to https://github.com/actions/virtual-environments/blob/main/images/linux/Ubuntu2004-README.md#environment-variables-3
  #   but change ANDROID_SDK_ROOT path to /root/Android/Sdk for android studio auto-sync
  # env ANDROID_SDK_ROOT, ANDROID_NDK_ROOT, ANDROID_NDK_HOME will be set in .bashrc_local
  mkdir -p /root/Android/Sdk/ndk/ && \
  mv android-ndk-r25b /root/Android/Sdk/ndk/ && \
  cd /root/Android/Sdk/ && \
  ln -s $(pwd)/ndk/android-ndk-r25b $(pwd)/ndk/25.1.8937393 && \
  ln -s $(pwd)/ndk/android-ndk-r25b $(pwd)/ndk-bundle

# install clang, refer to https://apt.llvm.org/
RUN wget https://apt.llvm.org/llvm.sh && \
  chmod +x llvm.sh && \
  ./llvm.sh all && \
  update-alternatives --install /usr/bin/clang clang /usr/bin/clang-15 100 && \
  update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-15 100 && \
  update-alternatives --install /usr/bin/clang-cpp clang-cpp /usr/bin/clang-cpp-15 100 && \
  update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-15 100 && \
  update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-15 100 && \
  update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-15 100 && \
  update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-15 100 && \
  update-alternatives --install /usr/bin/lldb-server lldb-server /usr/bin/lldb-server-15 100 && \
  # install additional liblldb-15-dev for lldb-mi compilation
  apt install -y liblldb-15-dev && \
  rm -rf /var/lib/apt/lists/* && \
  clang --version && \
  rm -f llvm.sh

# for jre/jdk installation
RUN mkdir -p /usr/share/man/man1

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
  echo "X11UseLocalhost no" >> /etc/ssh/sshd_config && \
  echo "Port 13191" >> /etc/ssh/sshd_config
RUN service ssh start

# vscode settings
COPY settings.json /root/.vscode-server/data/Machine/

# allow root to run sudo
RUN usermod -a -G sudo root

# install additonal packages for building or application depedencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --no-install-recommends -y \
  libz-dev libpulse-dev libasound2-dev libssl-dev \
  yasm nasm ffmpeg coturn \
  && rm -rf /var/lib/apt/lists/*

# set workspace
WORKDIR /root/workspace

# install conda for python, https://docs.anaconda.com/anaconda/install/silent-mode/
RUN wget --progress=dot:mega https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
  bash ~/miniconda.sh -b -p $HOME/miniconda && \
  rm -f ~/miniconda.sh && \
  ~/miniconda/bin/conda init zsh

# install meson
RUN pip install meson && \
  meson --version

# install nvm and nodejs
# https://github.com/nvm-sh/nvm#install--update-script
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash && \
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
RUN export CMAKE_VERSION="3.25.1" && \
  wget --progress=dot:mega https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz && \
  tar -zxf cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz && \
  mv cmake-${CMAKE_VERSION}-linux-x86_64 /usr/local/ && \
  rm cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz && \
  cd /usr/local/cmake-${CMAKE_VERSION}-linux-x86_64/ && \
  stow -v --ignore=man . && \
  cmake --version

# install ninja
RUN wget --progress=dot:mega https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip && \
  unzip ninja-linux.zip && \
  mv ninja /usr/local/bin/ && \
  rm -f ninja-linux.zip && \
  ninja --version

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

# install valgrind
RUN wget --progress=dot:mega --no-check-certificate https://sourceware.org/pub/valgrind/valgrind-3.20.0.tar.bz2 -O valgrind-3.20.0.tar.bz2 && \
  tar -xjf valgrind-3.20.0.tar.bz2 && \
  cd valgrind-3.20.0 && \
  ./configure --enable-only64bit && \
  make -j $(nproc) && make install && \
  cd ../ && \
  which valgrind && \
  /usr/local/bin/valgrind --version && \
  rm -rf ./valgrind*

# install bear, https://github.com/rizsotto/Bear/blob/master/INSTALL.md
RUN git clone -n https://github.com/rizsotto/Bear.git && \
  cd Bear && git checkout 3.0.21 && \
  mkdir -p build && cd build && \
  cmake -DENABLE_UNIT_TESTS=OFF -DENABLE_FUNC_TESTS=OFF ..  && \
  make && make install && \
  cd ../../ && \
  /usr/local/bin/bear --version && \
  rm -rf ./Bear

# install depot_tools: https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html#_setting_up
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

# install lldb-mi
RUN git clone https://github.com/lldb-tools/lldb-mi.git && \
  mkdir -p lldb-mi/build && \
  cd lldb-mi/build && \
  cmake .. -GNinja && \
  ninja install && \
  cd ../.. && \
  rm -rf lldb-mi

# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment

# lanuch via ssh by default
ENTRYPOINT ["/usr/sbin/sshd", "-D"]


LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/containers



