
FROM wangyoucao577/centos7-gcc7.4

# install latset boost
RUN mkdir -p boost && \
    cd boost && \
    wget --progress=dot:mega https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.tar.gz && \
    tar zxf boost_1_70_0.tar.gz && \
    cd boost_1_70_0 && \
    ./bootstrap.sh && \
    ./b2 install;exit 0 && \
    cd ../../ && \
    rm -rf boost

# link for install thrift
RUN ln -s /usr/local/lib/libboost_unit_test_framework.a /usr/local/lib64/libboost_unit_test_framework.a

ENV LIBRARY_PATH=/usr/lib64:$LIBRARY_PATH

# install thrift
RUN wget --progress=dot:mega https://github.com/apache/thrift/archive/0.12.0.tar.gz && \
    tar zxf 0.12.0.tar.gz && \
    cd thrift-0.12.0 && \
    ./bootstrap.sh && \
    ./configure --with-boost=/usr/local && \
    make && \
    make install && \
    cd ../ && \
    rm -rf ./thrift-0.12.0 && \
    rm -f 0.12.0.tar.gz 


# labels
LABEL maintainer="wangyoucao577@gmail.com"
