# 使用 Node.js 20 镜像
FROM node:20-slim

# 【完美绕过】：使用自带的 npm 全局安装 pm2，稳如老狗
RUN npm install -g pm2

# 启用 Corepack 安装 pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

WORKDIR /app

# 复制依赖文件
COPY package.json pnpm-lock.yaml ./

# 正常安装业务依赖
RUN pnpm install

# 复制其余源代码
COPY . .

# 执行构建
RUN pnpm build

# 暴露端口
EXPOSE 3000

# 启动服务
CMD ["pm2-runtime", "start", "process.json"]
