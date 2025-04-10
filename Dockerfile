# 构建阶段：安装依赖并编译原生模块
FROM --platform=linux/amd64 node:18-alpine AS builder

# 安装编译依赖（Python、make、g++ 和 SQLite 开发库）
RUN apk add --no-cache python3 make g++ sqlite-dev

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package.json package-lock.json ./

# 安装生产依赖，并强制从源码编译 better-sqlite3
RUN npm ci --production --force \
    && npm rebuild better-sqlite3 --build-from-source

# ----------------------------
# 生产阶段：轻量级运行环境
FROM --platform=linux/amd64 node:18-alpine

# 安装 SQLite 运行时库（部分 Alpine 环境需要）
RUN apk add --no-cache sqlite

# 设置工作目录
WORKDIR /app

# 从构建阶段复制已编译的 node_modules
COPY --from=builder /app/node_modules ./node_modules

# 复制项目代码（注意通过 .dockerignore 过滤非必要文件）
COPY . .

# 清理 npm 缓存（减少镜像体积）
RUN npm cache clean --force

# 启动命令
CMD ["npm", "run", "start"]
