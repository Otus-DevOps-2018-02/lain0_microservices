# docker
- version:
`docker version`
- info:
`docker info`
- running containers list:
### `docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.CreatedAt}}\t{{.Names}}"`
`docker ps`
- all containers list:
`docker ps -a`
- list all saves docker images:
`docker images`
- docker run (creates new container):
`docker run` = `docker create + docker start + docker attach*`
 * while using -i option for foreground mode
`docker run -it ubuntu:16.04 /bin/bash`
- start existing docker container:
`docker start 'container_id'`
- attach terminal to docker container
`docker attach 'container_id'`
### exin containet Ctrl+p Ctrl+q after `docker attach`
- `docker create` is used when no need to start container immediately
- exec process inside an existing docker container:
`docker exec -it <u_container_id> bash`
- create image from container
`docker commit container_id imagename:tagname`
- show diff from last container before
`docker diff 'container_id'`
- build image
`docker build -t image_name:tag_name .`
- create tag:
`docker tag reddit:latest <your-login>/otus-reddit:1.0`
- `docker login` for loginning to dockerhub.com
#################################
# docker-compose

#################################
# docker-machine
- create new docker vm host
`docker-machine create hostname`
- switch between docker remote vm hosts
`eval $(docker-machine env hostname)`
- switch to local docker
`eval $(docker-machine env --unset)`
- rm vm host
`docker-machine rm hostname`
- list docker-machines vm hosts:
`docker-machine ls`
- ssh
`docker-machine ssh hostname`
