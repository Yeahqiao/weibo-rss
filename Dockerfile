# 使用 Node.js 20 镜像
FROM node:20-slim

# 启用 Corepack 安装 pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

WORKDIR /app

# 先复制依赖文件，利用 Docker 缓存机制
COPY package.json pnpm-lock.yaml ./

# 正常安装依赖
RUN pnpm install

# 复制其余所有源代码
COPY . .

# 执行正常的构建流程
RUN pnpm build

# 暴露端口
EXPOSE 3000

# 启动服务
CMD ["node", "dist/index.js"]
