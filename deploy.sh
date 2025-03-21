#!/bin/bash

# 设置环境变量
ENVIRONMENT=${1:-dev}

# 部署RDS MySQL数据库
aws cloudformation deploy \
  --template-file aws/rds-mysql.yml \
  --stack-name strapi5-rds-mysql-${ENVIRONMENT} \
  --parameter-overrides Environment=${ENVIRONMENT} \
  --capabilities CAPABILITY_IAM

# 获取RDS数据库信息
DB_ENDPOINT=$(aws cloudformation describe-stacks \
  --stack-name strapi5-rds-mysql-${ENVIRONMENT} \
  --query 'Stacks[0].Outputs[?OutputKey==`DBEndpoint`].OutputValue' \
  --output text)

# 部署S3存储桶和CloudFront
aws cloudformation deploy \
  --template-file aws/cloudfront.yml \
  --stack-name strapi5-cloudfront-${ENVIRONMENT} \
  --parameter-overrides Environment=${ENVIRONMENT} \
  --capabilities CAPABILITY_IAM

# 获取S3存储桶和CloudFront信息
S3_BUCKET=$(aws cloudformation describe-stacks \
  --stack-name strapi5-cloudfront-${ENVIRONMENT} \
  --query 'Stacks[0].Outputs[?OutputKey==`S3BucketName`].OutputValue' \
  --output text)
CLOUDFRONT_DOMAIN=$(aws cloudformation describe-stacks \
  --stack-name strapi5-cloudfront-${ENVIRONMENT} \
  --query 'Stacks[0].Outputs[?OutputKey==`CloudFrontDomain`].OutputValue' \
  --output text)

# 生成.env文件
cat << EOF > .env.${ENVIRONMENT}
# Server
HOST=0.0.0.0
PORT=1337

# Database
DATABASE_CLIENT=mysql
DATABASE_HOST=${DB_ENDPOINT}
DATABASE_PORT=3306
DATABASE_NAME=strapi5-mysql-${ENVIRONMENT}
DATABASE_USERNAME=strapi5
DATABASE_PASSWORD=strapi5_pw
DATABASE_SSL=false

# AWS Configuration
AWS_BUCKET=${S3_BUCKET}
CLOUDFRONT_DOMAIN_NAME=${CLOUDFRONT_DOMAIN}
EOF

echo "Deployment completed and .env.${ENVIRONMENT} file generated."