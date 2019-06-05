
FROM centos:7

# alternatively `-j` to enable parallel compile
ARG MAKE_EXTRA_ARGS=

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
  yum update -y && \
  yum groupinstall -y "Development Tools" && \
  yum install -y \
    wget \
    vim \
    zlib-devel \
    libevent-devel \
    libffi-devel \
    openssl-devel

# install git 2.x
RUN yum remove -y git && \
  yum install -y https://centos7.iuscommunity.org/ius-release.rpm && \
  yum install -y git2u

# install gcc-7.4.0
RUN wget --progress=dot:mega https://github.com/gcc-mirror/gcc/archive/gcc-7_4_0-release.tar.gz && \
  tar -xzf gcc-7_4_0-release.tar.gz && \
  cd gcc-gcc-7_4_0-release && \
  ./contrib/download_prerequisites && \
  mkdir build && \
  cd build && \
  ../configure --prefix=/usr/local/gcc-7_4_0/ --disable-multilib --enable-languages=c,c++ --enable-checking=release --with-system-zlib && \
  make ${MAKE_EXTRA_ARGS} && \
  yum remove -y gcc && \ 
  make install-strip && \
  cd / && \
  rm -rf gcc-gcc-7_4_0-release gcc-7_4_0-release.tar.gz

# install cmake3
RUN wget --progress=dot:mega https://github.com/Kitware/CMake/releases/download/v3.14.1/cmake-3.14.1-Linux-x86_64.tar.gz && \
  tar -zxf cmake-3.14.1-Linux-x86_64.tar.gz && \
  mv cmake-3.14.1-Linux-x86_64 /usr/local/ && \
  rm -f cmake-3.14.1-Linux-x86_64.tar.gz

# install libtool by source
RUN wget --progress=dot:mega http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz && \
  tar -zxf libtool-2.4.6.tar.gz && \
  cd libtool-2.4.6 && \
  ./configure && \
  make ${MAKE_EXTRA_ARGS} && \
  make install && \
  cd .. && \
  rm -rf libtool-2.4.6 libtool-2.4.6.tar.gz

# install go
RUN wget --progress=dot:mega https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz && \
  tar -zxf go1.12.5.linux-amd64.tar.gz && \
  mv go /usr/local/ && \
  rm -f go1.12.5.linux-amd64.tar.gz

# install python2.7
RUN wget --progress=dot:mega https://www.python.org/ftp/python/2.7.16/Python-2.7.16.tgz && \
  tar -zxf Python-2.7.16.tgz && \
  cd Python-2.7.16 && \
  ./configure --enable-optimizations  --prefix=/usr/local && \
  make ${MAKE_EXTRA_ARGS} && \
  make install && \
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
  python get-pip.py && \
  cd .. && \
  rm -rf Python-2.7.16 Python-2.7.16.tgz

# install python3
RUN wget --progress=dot:mega https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz && \
  tar -zxf Python-3.7.3.tgz && \
  cd Python-3.7.3 && \
  ./configure --enable-optimizations  --prefix=/usr/local && \
  make ${MAKE_EXTRA_ARGS} && \
  make install && \
  cd .. && \
  rm -rf Python-3.7.3 Python-3.7.3.tgz

# set env
ENV GCC_HOME=/usr/local/gcc-7_4_0
ENV CMAKE_HOME=/usr/local/cmake-3.14.1-Linux-x86_64
ENV GO_HOME=/usr/local/go
ENV PATH=${GCC_HOME}/bin/:${CMAKE_HOME}/bin/:${GO_HOME}/bin/:$PATH
ENV CPATH=${GCC_HOME}/include/:$CPATH
ENV LIBRARY_PATH=${GCC_HOME}/lib64/:${GCC_HOME}/lib/:${GCC_HOME}/lib/gcc/x86_64-pc-linux-gnu/7.4.0/:$LIBRARY_PATH
ENV LD_LIBRARY_PATH=${GCC_HOME}/lib64/:${GCC_HOME}/lib/:${GCC_HOME}/lib/gcc/x86_64-pc-linux-gnu/7.4.0/:$LD_LIBRARY_PATH


# labels
LABEL maintainer="wangyoucao577@gmail.com"
