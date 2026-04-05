FROM ghcr.io/ten-framework/ten_agent_build:0.7.14

# avoid interactive during apt install
ARG DEBIAN_FRONTEND=noninteractive

# Install basic packages
RUN apt-get update && apt-get install --no-install-recommends -y \
  sudo zsh openssh-server \
  less vim curl wget rsync git git-lfs jq zip unzip rsyslog \
  tmux tree stow net-tools netcat \
  && rm -rf /var/lib/apt/lists/*

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
  echo "Port 13171" >> /etc/ssh/sshd_config && \
  echo "AcceptEnv GITHUB_* TEN_*" >> /etc/ssh/sshd_config
RUN service ssh start

# allow root to run sudo
RUN usermod -a -G sudo root

# set workspace
WORKDIR /root/workspace


# install gh cli
RUN (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

# install coding agents
RUN npm i -g @openai/codex
RUN curl -fsSL https://claude.ai/install.sh | bash
RUN curl -fsSL https://cli.kiro.dev/install | bash
RUN npm install -g @google/gemini-cli
RUN wget https://desktop-release.q.us-east-1.amazonaws.com/latest/kiro-cli.deb && \
	dpkg -i kiro-cli.deb || true && \
    apt-get install -y -f && \
    rm -f kiro-cli.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment

# lanuch via ssh by default
ENTRYPOINT ["/usr/sbin/sshd", "-D"]


LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/containers



