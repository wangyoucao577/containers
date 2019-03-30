
FROM centos:7

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
  yum update -y && \
  yum groupinstall -y "Development Tools" && \
  yum install -y wget vim zlib-devel

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
  make -j && \
  yum remove -y gcc && \ 
  make install-strip && \
  cd / && \
  rm -rf gcc-gcc-7_4_0-release gcc-7_4_0-release.tar.gz

# set env
COPY bashrc /root/.bashrc

# labels
LABEL maintainer="wangyoucao577@gmail.com"
