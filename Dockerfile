# 使用官方的 linuxserver/code-server 基础镜像
FROM linuxserver/code-server:latest

# 基于 linuxserver/code-server:latest 镜像
FROM linuxserver/code-server:latest

# 安装 nvm 所需的依赖
RUN apt-get update && apt-get install -y \
    curl \
    git \
    bash \
    build-essential \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装 nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# 配置 nvm 环境变量
ENV NVM_DIR=/root/.nvm
ENV PATH=${NVM_DIR}/versions/node/v20.11.1/bin:${PATH}

# 加载 nvm 脚本
RUN [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 使用 nvm 安装 Node.js v20.11.1
RUN [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install 20.11.1 && nvm use 20.11.1

# 可选：验证 Node.js 和 npm 版本
RUN node -v && npm -v

# 启动 code-server
CMD ["code-server"]
