#!/bin/bash

read -p "Enter envrionment dev|prod: " ENVIRONMENT; echo
read -p "Enter database URL: " DBHOST; echo
read -s -p "Enter database password for ctf user: " DBPASSWORD; echo
read -s -p "Enter secret key for CTF app: " SECRETKEY; echo
read -p "Enter redis url: " REDISHOST; echo
read -p "Enter S3 bucket name: " BUCKET; echo

# add the params to param store

aws ssm put-parameter --overwrite --type "SecureString" \
  --name "/${ENVIRONMENT}/SECRET_KEY" \
  --value "$SECRETKEY" | jq

aws ssm put-parameter --overwrite --type "SecureString" \
  --name "/${ENVIRONMENT}/DATABASE_URL" \
  --value "mysql+pymysql://ctfd:${DBPASSWORD}@${DBHOST}/ctfd" | jq

aws ssm put-parameter --overwrite --type "SecureString" \
  --name "/${ENVIRONMENT}/REDIS_URL" \
  --value "redis://${REDISHOST}:6379" | jq

aws ssm put-parameter --overwrite --type "SecureString" \
  --name "/${ENVIRONMENT}/AWS_S3_BUCKET" \
  --value "$BUCKET" | jq