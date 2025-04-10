# 构建阶段
FROM node:18-alpine as builder

WORKDIR /app

COPY package*.json ./

# 删除可能存在的不兼容的 node_modules 目录
RUN rm -rf node_modules

## 设置淘宝镜像源
#RUN npm config set registry https://registry.npmmirror.com

# 安装所有依赖
RUN npm install

COPY . .

RUN npm run build

# 运行阶段
FROM node:18-alpine

WORKDIR /app

# 只复制生产环境需要的文件
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/build ./build
COPY --from=builder /app/public ./public

EXPOSE 1337

CMD ["npm", "run", "start"]
