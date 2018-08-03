#
export USER_NAME = lain0

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## HELP!
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


build-microservices:
	for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done

build-prometheus:
	cd monitoring\prometheus && build -t $(USER_NAME)/prometheus .

down: ## docker-compose down
	cd docker && docker-compose down

gcp: ## eval to gcp host
	eval $(docker-machine env docker-host)

git-add:
	git add -u

push-dockerhub:
	docker login
	docker images --format "{{.Repository}}"|grep lain0 |uniq | xargs -I image_name docker push image_name:latest

tag: ## add tag rc
	docker images --format "{{.Repository}}"|grep lain0 |uniq | xargs -I image_name docker tag image_name:rc
up: ## docker-compose up -d
	cd docker && docker-compose up -d
