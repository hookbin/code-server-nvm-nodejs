# 使用官方的 linuxserver/code-server 基础镜像
FROM linuxserver/code-server:latest

# 安装 nvm 所需的依赖
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo

# 设置环境变量
ENV NVM_DIR=/usr/local/nvm
ENV NODE_VERSION=20.11.1

# Use bash for the shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Create a script file sourced by both interactive and non-interactive bash shells
ENV BASH_ENV /home/user/.bash_env
RUN touch "${BASH_ENV}"
RUN echo '. "${BASH_ENV}"' >> ~/.bashrc

# Download and install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | PROFILE="${BASH_ENV}" bash
RUN echo node > .nvmrc
RUN nvm install $NODE_VERSION
RUN nvm alias default $NODE_VERSION
RUN nvm use default

# 确保后续命令可以使用 nvm 和 node
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# 可选：验证 Node.js 和 npm 版本
RUN node -v && npm -v
