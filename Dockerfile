# 使用官方的 linuxserver/code-server 基础镜像
FROM linuxserver/code-server:4.96.4-ls254

# Set the SHELL to bash with pipefail option
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# 安装 nvm 所需的依赖
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*
    
# Create a script file sourced by both interactive and non-interactive bash shells
ENV BASH_ENV=/config/.bash_env
RUN touch "${BASH_ENV}"
RUN echo '. "${BASH_ENV}"' >> ~/.bashrc

# 加载 nvm 并安装 Node.js v20.11.1
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | PROFILE="${BASH_ENV}" bash
RUN echo node > .nvmrc
RUN nvm install 20.11.1
RUN nvm use 20.11.1
RUN nvm alias default 20.11.1

# 可选：验证 Node.js 和 npm 版本
RUN node -v && npm -v

EXPOSE 8443
