# 使用 Node.js 官方镜像
FROM node:18-slim

# 安装 pnpm
RUN npm install -g pnpm

# 设置工作目录
WORKDIR /app

# 关键：这里我们只复制 package.json 和 pnpm-lock.yaml
COPY package.json pnpm-lock.yaml ./

# 使用 pnpm 安装依赖
RUN pnpm install --frozen-lockfile

# 复制其余源代码
COPY . .

# 执行构建
RUN pnpm build

# 暴露端口（项目默认是 3000）
EXPOSE 3000

# 启动命令
CMD ["node", "dist/index.js"]
