# 【核心修复】：放弃 slim，改用自带完整 C++ 编译工具链的 Node 18
FROM node:18

# 全局安装 pm2
RUN npm install -g pm2

# 启用 Corepack 安装 pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

WORKDIR /app

# 复制依赖文件
COPY package.json pnpm-lock.yaml ./

# 正常安装业务依赖（这次 leveldown 有编译工具了，不会再失败）
RUN pnpm install

# 复制其余源代码
COPY . .

# 执行构建
RUN pnpm build

# 暴露端口
EXPOSE 3000

# 启动服务
CMD ["pm2-runtime", "start", "process.json"]
