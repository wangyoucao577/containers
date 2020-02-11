
FROM telenavmap/osrm-backend-dev:latest


# install extra tools
RUN apt-get install -y openssh-server gdb

# latest vscode extension
RUN cd /workspace && \
  wget --progress=dot:mega https://github.com/microsoft/vscode-cpptools/releases/download/0.26.3/cpptools-linux.vsix

# prepare for sshd
RUN mkdir -p /root/.ssh
COPY jay_easy_rsa.pub /root/.ssh/
RUN cat /root/.ssh/jay_easy_rsa.pub >> /root/.ssh/authorized_keys && \
  chmod 600 /root/.ssh/authorized_keys && \
  chmod 700 /root/.ssh/ && \
  chmod 755 /root/
RUN service ssh start

COPY .tmux.conf /root/
COPY .vimrc /root/
COPY .bashrc /root/

# set env
ENV GO_HOME=/usr/local/go
ENV PATH=${GO_HOME}/bin/:$PATH
ENV GOPATH=/workspace/go


ENTRYPOINT ["/usr/sbin/sshd", "-D"]

# labels
LABEL maintainer="wangyoucao577@gmail.com"
