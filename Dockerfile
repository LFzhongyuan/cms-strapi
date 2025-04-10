FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

# 删除可能存在的不兼容的 node_modules 目录
RUN rm -rf node_modules

# 确保目录可写
RUN chown -R node:node /app

USER node

RUN npm install

COPY . .
RUN npm run build
EXPOSE 1337
CMD ["npm", "run", "start"]
