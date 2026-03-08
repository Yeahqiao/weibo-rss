# 使用 Node.js 20 镜像
FROM node:20-slim

# 启用 Corepack 安装 pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

WORKDIR /app

# 复制依赖文件
COPY package.json pnpm-lock.yaml ./

# 安装依赖
RUN pnpm install

# 复制其余源代码
COPY . .

# 【核心修复】：在构建前强制开启 skipLibCheck
# 这会忽略 node_modules 里的那个 ___dirname 拼写错误
RUN npx json -I -f tsconfig.json -e "this.compilerOptions.skipLibCheck=true" || \
    sed -i 's/"compilerOptions": {/"compilerOptions": { "skipLibCheck": true, /' tsconfig.json

# 执行构建
RUN pnpm build

# 暴露端口
EXPOSE 3000

# 启动服务
CMD ["node", "dist/index.js"]
