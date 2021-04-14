SHELL := /bin/bash
APP_DIR := CTFd
AWS_ACCOUNT := 
REGION ?= us-east-1
ENV ?= dev


.PHONY: up down stop deploy push nginx buildx buildx-prepare ecr-login

up:
	cd $(APP_DIR) && docker-compose up

down:
	cd $(APP_DIR) && docker-compose down

stop:
	cd $(APP_DIR) && docker-compose stop

build:
	cd $(APP_DIR) && docker build -t ctf:latest .
	cd $(APP_DIR) && docker build -t nginx:latest nginx

buildx-create:
	docker buildx create --use --name mybuilder

buildx-use:
	docker buildx use mybuilder

ecr-login:
	aws ecr get-login-password --region $(REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT).dkr.ecr.$(REGION).amazonaws.com

# experimental docker buildx, needed if building on non amd64 archs like M1
buildx: ecr-login buildx-use
	cd $(APP_DIR) && docker buildx build \
		--load \
		--platform linux/amd64 --tag $(AWS_ACCOUNT).dkr.ecr.$(REGION).amazonaws.com/$(ENV)-ctf:latest .
	
	cd nginx && docker buildx build \
		--load \
		--platform linux/amd64 --tag $(AWS_ACCOUNT).dkr.ecr.$(REGION).amazonaws.com/$(ENV)-nginx:latest .

push: ecr-login
	docker push $(AWS_ACCOUNT).dkr.ecr.$(REGION).amazonaws.com/$(ENV)-ctf:latest
	docker push $(AWS_ACCOUNT).dkr.ecr.$(REGION).amazonaws.com/$(ENV)-nginx:latest

deploy:
	cd terraform && scripts/deploy_all.sh $(ENV)