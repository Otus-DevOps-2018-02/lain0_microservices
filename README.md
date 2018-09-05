# lain0_microservices

[![Build Status](https://api.travis-ci.org/Otus-DevOps-2018-02/lain0_microservices.svg?branch=master)](https://api.travis-ci.org/Otus-DevOps-2018-02/lain0_microservices)

## hw13 Docker
[67]: https://docs.docker.com/install/linux/docker-ce/ubuntu/
`docker run`
[68]: https://docs.docker.com/engine/reference/commandline/commit/#examples
1) install [Docker][67] via `pip install docker`
docker parametres:

- -i - run container in foreground mode (docker attach)
- -d - run container in background mode
- -t - creates tty

```
docker run -it ubuntu:16.04 bash
docker run -dt nginx:latest
docker exec -it <u_container_id> bash
docker commit container_id imagename:tagname
```

## hw14 Docker containers
[69]: https://console.cloud.google.com/compute
[70]: https://docs.docker.com/machine/install-machine/
[71]: https://docs.docker.com/machine/install-machine/#install-bash-completion-scripts
[72]: https://github.com/jpetazzo/dind
[73]: https://docs.docker.com/engine/security/userns-remap/
[74]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-15/mongod.conf
[75]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-15/start.sh
[76]: https://hub.docker.com/
[77]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-15/push.log
[78]: https://docs.docker.com/engine/reference/commandline/tag/
Create docker project in [GCE][69] `docker-211106`

```
gcloud init
gcloud auth
```

install [Docker Machine][70]
1) Create docker host

```
export GOOGLE_PROJECT=docker-211106
docker-machine create --driver google \
  --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
  --google-machine-type n1-standard-1 \
  --google-zone europe-west1-b \
  docker-host
docker-machine ls
```
Switch to remote host: `eval $(docker-machine env docker-host)`

- PID namespace (process isolation)
- net namespace (network isolation)
- user namespaces (user isolation)
```
docker run --rm -ti tehbilly/htop
docker run --rm --pid host -ti tehbilly/htop
```

2) Create docker image
`docker build -t reddit:latest .`
run container
`docker run --name reddit -d --network=host reddit:lates`
docker-machine ls
open gce port tcp:9292
```
gcloud compute firewall-rules create reddit-app \
--allow tcp:9292 \
--target-tags=docker-machine \
--description="Allow PUMA connections" \
--direction=INGRESS
```
3) [Docker Hub][76]
Login to Docker HUB:
`docker login`
[tag docker image][78]
`docker tag reddit:latest <your-login>/otus-reddit:1.0`
push to docker hub
`docker push <your-login>/otus-reddit:1.0`
run on local docker env:
`docker run --name reddit -d -p 9292:9292 <your-login>/otus-reddit:1.0`
it works on localhost:9292

Edditional tests:
show logs:
`docker logs reddit -f`
attach to docker container:
`docker exec -it reddit bash`
stop container:
`kill -9 1`
`docker start reddit`
stop and rm container
`docker stop reddit && docker rm reddit`
start without app
`docker run --name reddit --rm -it <your-login>/otus-reddit:1.0 bash`

`docker inspect <your-login>/otus-reddit:1.0`
`docker inspect <your-login>/otus-reddit:1.0 -f '{{.ContainerConfig.Cmd}}'`
`docker run --name reddit -d -p 9292:9292 <your-login>/otus-reddit:1.0`
`docker exec -it reddit bash`
  - mkdir /test1234
  - touch /test1234/testfile
  - rmdir /opt
  - exit
`docker diff reddit`
`docker stop reddit && docker rm reddit`
all changes removed
`docker run --name reddit --rm -it <your-login>/otus-reddit:1.0 bash`
  - ls /
