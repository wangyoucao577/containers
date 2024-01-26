FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

# nvidia-container-runtime envs, see https://github.com/NVIDIA/nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

# avoid interactive during apt install
ARG DEBIAN_FRONTEND=noninteractive

# Install basic packages
RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential pkg-config automake libtool gperf gdb \
  zsh openssh-server \
  python3-pip \
  less vim curl wget rsync git git-lfs jq zip unzip \
  tmux tree stow \
  iperf3 net-tools iputils-ping mtr dnsutils netcat iproute2 \
  sudo psmisc file htop atop sysstat strace elfutils pax-utils libc-bin \
  pciutils dmidecode \
  lsb-release software-properties-common gnupg2 autoconf \
  locales-all ca-certificates \
  xauth x11-apps \
  && rm -rf /var/lib/apt/lists/*

# install cudnn, tensorrt
# cudnn: https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html#package-manager-ubuntu-install
# versions: https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/
# tensorrt: https://docs.nvidia.com/deeplearning/tensorrt/install-guide/index.html#maclearn-net-repo-install
# tensorrt: https://docs.nvidia.com/deeplearning/tensorrt/quick-start-guide/index.html#installing-debian
# be aware that tensorrt 8.5.1.7-1+cuda11.8 compatible lower cuda11
RUN wget --progress=dot:mega --no-check-certificate https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
  mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
  apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub && \
  add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" && \
  apt-get update && \
  apt-get install --no-install-recommends -y tensorrt=8.5.2.2-1+cuda11.8 && \
  rm -rf /var/lib/apt/lists/*

# install clang, refer to https://apt.llvm.org/
RUN wget https://apt.llvm.org/llvm.sh && \
  chmod +x llvm.sh && \
  ./llvm.sh all && \
  update-alternatives --install /usr/bin/clang clang /usr/bin/clang-17 100 && \
  update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-17 100 && \
  update-alternatives --install /usr/bin/clang-cpp clang-cpp /usr/bin/clang-cpp-17 100 && \
  update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-17 100 && \
  update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-17 100 && \
  update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-17 100 && \
  update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-17 100 && \
  update-alternatives --install /usr/bin/lldb-server lldb-server /usr/bin/lldb-server-17 100 && \
  # install additional liblldb-17-dev for lldb-mi compilation
  apt install -y liblldb-17-dev && \
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
  echo "X11UseLocalhost no" >> /etc/ssh/sshd_config 
RUN service ssh start

# allow root to run sudo
RUN usermod -a -G sudo root

# install additonal packages for building or application depedencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --no-install-recommends -y \
  libz-dev libpulse-dev libasound2-dev libssl-dev \
  nasm yasm ffmpeg coturn \
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

# install cmake
RUN export CMAKE_VERSION="3.28.1" && \
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
  cd Bear && git checkout 3.1.3 && \
  mkdir -p build && cd build && \
  cmake -DENABLE_UNIT_TESTS=OFF -DENABLE_FUNC_TESTS=OFF ..  && \
  make && make install && \
  cd ../../ && \
  /usr/local/bin/bear --version && \
  rm -rf ./Bear

# install go
RUN wget --progress=dot:mega --no-check-certificate https://go.dev/dl/$(curl https://go.dev/VERSION?m=text).linux-amd64.tar.gz -O go.linux-amd64.tar.gz && \
  tar -zxf go.linux-amd64.tar.gz && \
  mv go /usr/local/ && \
  rm -f go.linux-amd64.tar.gz && \
  mkdir -p go/bin /go/src go/pkg

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



