# 使用官方的 linuxserver/code-server 基础镜像
FROM linuxserver/code-server:4.96.4-ls254

# Set the SHELL to bash with pipefail option
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Prevent dialog during apt install
ENV DEBIAN_FRONTEND noninteractive

# 安装 nvm 所需的依赖
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set locale
RUN locale-gen en_US.UTF-8
RUN bash --version | head -n 1
RUN zsh --version
RUN ksh --version || true
RUN dpkg -s dash | grep ^Version | awk '{print $2}'
RUN git --version
RUN curl --version
RUN wget --version
RUN useradd -ms /bin/bash nvm
COPY . /home/nvm/.nvm/
RUN chown nvm:nvm -R "/home/nvm/.nvm"
RUN echo 'nvm ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
USER nvm
ENV BASH_ENV /config/.bash_env
RUN touch "$BASH_ENV"
RUN echo '. "$BASH_ENV"' >> "$HOME/.bashrc"
RUN echo 'export NVM_DIR="$HOME/.nvm"'                                       >> "$BASH_ENV"
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> "$BASH_ENV"
RUN echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> "$BASH_ENV"

# 加载 nvm 并安装 Node.js v20.11.1
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | PROFILE="${BASH_ENV}" bash
RUN echo node > .nvmrc
RUN nvm install 20.11.1
RUN nvm use 20.11.1
RUN nvm alias default 20.11.1

# 可选：验证 Node.js 和 npm 版本
RUN node -v && npm -v

EXPOSE 8443
