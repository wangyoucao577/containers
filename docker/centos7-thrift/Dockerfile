
FROM wangyoucao577/centos7-gcc7.4

RUN yum update -y && \
  yum install -y libevent-devel openssl-devel

# install latset boost
RUN wget --progress=dot:mega https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.tar.gz && \
    tar xvf boost_1_70_0.tar.gz && \
    cd boost_1_70_0 && \
    ./bootstrap.sh && \
    ./b2 install && \
    cd ../ && \
    rm -rf ./boost_1_70_0 boost_1_70_0.tar.gz

# link for install thrift
RUN ln -s /usr/local/lib/libboost_unit_test_framework.a /usr/local/lib64/libboost_unit_test_framework.a

# install thrift
RUN wget --progress=dot:mega https://github.com/apache/thrift/archive/v0.12.0.tar.gz && \
    tar vxf v0.12.0.tar.gz && \
    cd thrift-0.12.0 && \
    ./bootstrap.sh && \
    ./configure --with-boost=/usr/local && \
    make && \
    make install && \
    cd ../ && \
    rm -rf ./thrift-0.12.0 v0.12.0.tar.gz && \
    thrift --help

# labels
LABEL maintainer="wangyoucao577@gmail.com"
