# 使用 Node.js 18 官方镜像
FROM --platform=linux/amd64 node:18-alpine

# 安装编译依赖（Python、make、g++、SQLite 开发库）
RUN apk add --no-cache python3 make g++ sqlite-dev

# 设置工作目录
WORKDIR /app

# 复制 package 文件
COPY package.json package-lock.json ./

# 安装依赖并编译原生模块
RUN npm ci --force && npm rebuild better-sqlite3 --build-from-source

# 复制项目源码
COPY . .

# 执行构建命令生成 dist 目录
RUN npm run build

# 清理编译依赖（可选，但建议保留以支持 future 模块更新）
# RUN apk del python3 make g++

# 启动命令（直接运行，无需再次构建）
CMD ["npm", "start"]
