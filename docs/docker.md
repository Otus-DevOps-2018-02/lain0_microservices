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
- run new container:
`docker run -it ubuntu:16.04 /bin/bash`
- start existing docker container:
`docker start 'container_id'`
- attach terminal to docker container
`docker attach 'container_id'`
### exin containet Ctrl+p Ctrl+q after `docker attach`
- docker run:
`docker run` = `docker create + docker start +
docker attach*`
 * while using -i option for foreground mode
- `docker create` is used when no need to start container immediately
- exec process inside docker container:
`docker exec -it <u_container_id> bash`
- create image from container
`docker commit`
- show diff from last container before
`docker diff 'container_id'`
#################################
# docker-compose
