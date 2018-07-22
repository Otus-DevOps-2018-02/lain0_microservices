# lain0_microservices

[![Build Status](https://api.travis-ci.org/Otus-DevOps-2018-02/lain0_microservices.svg?branch=master)](https://api.travis-ci.org/Otus-DevOps-2018-02/lain0_microservices)

# hw13 Docker
[67]: https://docs.docker.com/install/linux/docker-ce/ubuntu/
`docker run`
1) install [Docker][67] via `pip install docker`
docker parametres:
- -i - run container in foreground mode (docker attach)
- -d - run container in background mode
- -t - creates tty
```
docker run -it ubuntu:16.04 bash
docker run -dt nginx:latest
docker exec -it <u_container_id> bash
```
### Task *
