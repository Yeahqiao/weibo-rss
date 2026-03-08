# 使用 Node.js 20 镜像
FROM node:20-slim

# 启用 Corepack 安装 pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

# 【核心新增】：全局安装 pm2
RUN pnpm install pm2 -g

WORKDIR /app

# 复制依赖文件
COPY package.json pnpm-lock.yaml ./

# 正常安装依赖
RUN pnpm install

# 复制其余源代码
COPY . .

# 执行构建 (这步刚才已经证明能跑通了)
RUN pnpm build

# 暴露端口
EXPOSE 3000

# 【核心修改】：使用 pm2-runtime 读取原作者的配置来启动服务
CMD ["pm2-runtime", "start", "process.json"]
