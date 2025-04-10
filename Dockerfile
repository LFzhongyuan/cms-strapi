FROM node:18-alpine

WORKDIR /app

# 先复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm install --production

# 复制项目其他文件
COPY . .

# 构建 Strapi 项目
RUN npm run build

EXPOSE 1337

CMD ["npm", "run", "start"]
