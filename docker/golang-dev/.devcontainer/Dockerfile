FROM debian:stretch-slim

# Install necessary packages for proper system state
RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    curl \
    wget \
    vim \
    git \
    make \
    bash 

# install go
RUN wget --progress=dot:mega https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz && \
    tar -zxf go1.13.3.linux-amd64.tar.gz && \
    mv go /usr/local/ && \
    rm -f go1.13.3.linux-amd64.tar.gz && \
    mkdir -p /workspace/go/bin /workspace/go/src /workspace/go/pkg

# set env
ENV GO_HOME=/usr/local/go
ENV PATH=${GO_HOME}/bin/:$PATH
ENV GOPATH=/go

# golang tools
RUN mkdir -p /tmp/gotools \
    && cd /tmp/gotools \
    && GOPATH=/tmp/gotools GO111MODULE=on go get -v golang.org/x/tools/gopls@latest 2>&1 \
    && GOPATH=/tmp/gotools GO111MODULE=on go get -v \
    honnef.co/go/tools/...@latest \
    golang.org/x/tools/cmd/gorename@latest \
    golang.org/x/tools/cmd/goimports@latest \
    golang.org/x/tools/cmd/guru@latest \
    golang.org/x/lint/golint@latest \
    github.com/mdempsky/gocode@latest \
    github.com/cweill/gotests/...@latest \
    github.com/haya14busa/goplay/cmd/goplay@latest \
    github.com/sqs/goreturns@latest \
    github.com/josharian/impl@latest \
    github.com/davidrjenni/reftools/cmd/fillstruct@latest \
    github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest  \
    github.com/ramya-rao-a/go-outline@latest  \
    github.com/acroca/go-symbols@latest  \
    github.com/godoctor/godoctor@latest  \
    github.com/rogpeppe/godef@latest  \
    github.com/zmb3/gogetdoc@latest \
    github.com/fatih/gomodifytags@latest  \
    github.com/mgechev/revive@latest  \
    github.com/go-delve/delve/cmd/dlv@latest 2>&1 \
    #
    # Build Go tools w/o module support
    && GOPATH=/tmp/gotools go get -v github.com/alecthomas/gometalinter 2>&1 \
    #
    # Build gocode-gomod
    && GOPATH=/tmp/gotools go get -x -d github.com/stamblerre/gocode 2>&1 \
    && GOPATH=/tmp/gotools go build -o gocode-gomod github.com/stamblerre/gocode \
    #
    # Install Go tools
    && mv /tmp/gotools/bin/* /usr/local/bin/ \
    && mv gocode-gomod /usr/local/bin/ \
    #
    # Install golangci-lint
    && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/bin 2>&1 \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/gotools

WORKDIR /workspace/

# Expose service ports.
EXPOSE 8000

# Update this to "on" or "off" as appropriate
ENV GO111MODULE=auto
