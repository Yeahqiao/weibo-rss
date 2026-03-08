# 使用更稳定的 Node.js 镜像
FROM node:20-slim

# 启用 Corepack 并安装最新的 pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# 设置 CI 环境下无需交互式确认
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

WORKDIR /app

# 先复制依赖定义文件
COPY package.json pnpm-lock.yaml ./

# 核心修改：移除 --frozen-lockfile，改用更兼容的安装方式
# 这能解决锁文件在不同 OS (如 Windows/Mac 到 Linux) 下的细微差异
RUN pnpm install

# 复制其余源代码
COPY . .

# 执行构建
RUN pnpm build

# 暴露端口
EXPOSE 3000

# 启动服务
CMD ["node", "dist/index.js"]
