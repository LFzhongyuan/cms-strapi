# 使用 Node.js 18 作为基础镜像
FROM node:18

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制项目文件
COPY . .

# 构建 Strapi 项目
RUN npm run build

# 暴露 Strapi 默认端口
EXPOSE 1337

# 启动 Strapi 应用
CMD ["npm", "run", "start"]
