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

# 安装 nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# 确保后续命令可以使用 nvm 和 node
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# 可选：验证 Node.js 和 npm 版本
RUN node -v && npm -v