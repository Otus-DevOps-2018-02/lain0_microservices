# lain0_microservices

lain0 microservices repository

# hw13 Docker
[67]: https://docs.docker.com/install/linux/docker-ce/ubuntu/
`docker run`
1) install Docker[67] via `pip install docker`
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
