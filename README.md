# lain0_microservices

[![Build Status](https://api.travis-ci.org/Otus-DevOps-2018-02/lain0_microservices.svg?branch=master)](https://api.travis-ci.org/Otus-DevOps-2018-02/lain0_microservices)

## hw13 Docker
[67]: https://docs.docker.com/install/linux/docker-ce/ubuntu/
[68]: https://docs.docker.com/engine/reference/commandline/commit/#examples

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

# hw15 Docker Images Microservices
[79]: https://github.com/hadolint/hadolint
[80]: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
[81]: https://github.com/express42/reddit/archive/microservices.zip
[82]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-16/%D0%A1%D0%B5%D1%80%D0%B2%D0%B8%D1%81%20post-py
[83]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-16/%D0%A1%D0%B5%D1%80%D0%B2%D0%B8%D1%81%20comment
[84]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-16/%D0%A1%D0%B5%D1%80%D0%B2%D0%B8%D1%81%20ui
[85]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-16/%D0%A1%D0%B5%D1%80%D0%B2%D0%B8%D1%81%20ui%20-%20%D1%83%D0%BB%D1%83%D1%87%D1%88%D0%B0%D0%B5%D0%BC%20%D0%BE%D0%B1%D1%80%D0%B0%D0%B7
[86]: https://github.com/docker-library/ruby/blob/eca972d167cf4291de898e85aaf50d9a1929d4c7/2.5/alpine3.7/Dockerfile
[87]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-16/%D0%9F%D0%B5%D1%80%D0%B5%D0%B7%D0%B0%D0%BF%D1%83%D1%81%D0%BA%20%D0%BF%D1%80%D0%B8%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D1%8F
[88]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-16/%D0%9F%D0%B5%D1%80%D0%B5%D0%B7%D0%B0%D0%BF%D1%83%D1%81%D0%BA%20%D0%BF%D1%80%D0%B8%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D1%8F%20%D1%81%20volume

[docker linter][79]
install: `docker pull hadolint/hadolint`
usage: `docker run --rm -i hadolint/hadolint < Dockerfile`
```
docker run --rm -i hadolint/hadolint hadolint \
  --ignore DL3003 \
  --ignore DL3006 \
  - < Dockerfile
```

set remote docker env
```
docker-machine ls
eval $(docker-machine env docker-host)
```
1) Build Docker Images
Lets split monolith Docker image

load mongo image:
`docker pull mongo:latest`
build images *post-py* *comment* *ui*:
```
docker build -t lain0/post:1.0 ./post-py
docker build -t lain0/comment:1.0 ./comment
docker build -t lain0/ui:1.0 ./ui
```

Create new bridge network: `docker network create reddit`
Run containers connecting to network reddit:
```
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post lain0/post:1.0
docker run -d --network=reddit --network-alias=comment lain0/comment:1.0
docker run -d --network=reddit -p 9292:9292 lain0/ui:1.0
```
IP: `docker-machine ip docker-host`

### Task *
stop all containers: `docker kill $(docker ps -q)`
docker ls all networks: `docker network ls`


we need to set ENV to override ENV settings from dockerfiles:
 * POST_DATABASE_HOST
 * COMMENT_DATABASE_HOST
 * POST_SERVICE_HOST
 * COMMENT_SERVICE_HOST
```
docker run -d --network=reddit --network-alias=post_db2 --network-alias=comment_db2 mongo:latest
docker run -d --network=reddit --network-alias=post2 --env POST_DATABASE_HOST=post_db2 lain0/post:1.0
docker run -d --network=reddit --network-alias=comment2 --env COMMENT_DATABASE_HOST=comment_db2 lain0/comment:1.0
docker run -d --network=reddit --env POST_SERVICE_HOST=post2 --env COMMENT_SERVICE_HOST=comment2 -p 9292:9292 lain0/ui:1.0
```
IP: `docker-machine ip docker-host`
2) Optimize Dockerfiles
build from ubuntu:16.04
`docker build -t lain0/ui:2.0 ./ui`
build [ruby from alpine:3.7][86]

Create volume for database outside docker:
`docker volume create reddit_db`

```
docker kill $(docker ps -q)
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest
docker run -d --network=reddit --network-alias=post lain0/post:1.0
docker run -d --network=reddit --network-alias=comment lain0/comment:1.0
docker run -d --network=reddit -p 9292:9292 lain0/ui:2.0
```

alpine 3.8 not working va my Dockerfiles
fixed show.haml file - aded required=>true in no_name_value or no_comment_value

# hw16 Docker-compose networking docker image testing
[89]: https://docs.docker.com/compose/install/#install-compose
[90]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-17/docker-compose.yml
[91]: https://docs.docker.com/compose/compose-file/
[92]: https://docs.docker.com/compose/networking/

1) [Networking][92]
```
docker-machine ls
eval $(docker-machine env docker-host)
```
- net none
```
docker run --network none --rm -d --name net_test joffotron/docker-net-tools -c "sleep 100"
docker exec -ti net_test ifconfig
```
- net host
```
docker run --network host --rm -d --name net_test joffotron/docker-net-tools -c "sleep 100"
docker exec -ti net_test ifconfig
```
```
docker run --network host -d nginx
docker kill $(docker ps -q)
```
use ip net-namespaces
```
docker-machine ssh docker-host
sudo ln -s /var/run/docker/netns /var/run/netns
sudo ip netns ls
sudo ip netns exec default netstat -tulpn
```
- net bridge
create docker bridge `docker network create reddit --driver bridge`
use `--name <name>` for one name
use `--network-alias <alias-name>` for muiti alias names
```
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db  -v reddit_db:/data/db mongo:latest
docker run -d --network=reddit --name post lain0/post:1.0
docker run -d --network=reddit --name comment lain0/comment:13.0
docker run -d --network=reddit -p 9292:9292 lain0/ui:12.0
```
make two docker networks:
```
docker kill $(docker ps -q)
docker network create back_net --subnet=10.0.2.0/24
docker network create front_net --subnet=10.0.1.0/24

docker run -d --network=front_net -p 9292:9292 --name ui  lain0/ui:12.0
docker run -d --network=back_net --name comment  lain0/comment:13.0
docker run -d --network=back_net --name post  lain0/post:1.0
docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest
```
connect more network to containers:
`docker network connect <network> <container>`
```
docker network connect front_net post
docker network connect front_net comment
```
install `bridge-utils` on docker-host
```
docker-machine ssh docker-host
sudo apt-get update && sudo apt-get install bridge-utils
docker network ls
docker network inspect back_net
docker network inspect front_net
ifconfig | grep br
brctl show bridgename
sudo iptables -nL -t nat
ps ax | grep docker-proxy
```
2) [Docker-compose][89]
`pip install docker-compose`
```
docker kill $(docker ps -q)
export USERNAME=lain0
docker-compose up -d
docker-compose ps
```
```
docker network rm back_net
docker network rm front_net
docker-compose up -d
docker-compose ps
```
Docker-composer project name can be defined
- vs ENV - `COMPOSE_PROJECT_NAME`
- vs docker-compose cli env option `-p` / `--project-name`
- vs
```
tree -a
.
├── .docker-compose
│   └── project-name
└── docker-compose.yml
```

# hw17 GitlabCI Continuos Integration

[93]: https://docs.gitlab.com/ce/install/requirements.html
[94]: https://docs.gitlab.com/omnibus/README.html
[95]: https://docs.gitlab.com/omnibus/docker/README.html
[96]: https://gist.github.com/Nklya/c2ca40a128758e2dc2244beb09caebe1
[97]: https://gist.github.com/Nklya/ab352648c32492e6e9b32440a79a5113
[98]: https://gist.github.com/Nklya/d70ff7c6d1c02de8f18bcd049e904942
[99]: https://docs.gitlab.com/runner/register/

1) Installation GitlabCI
We create new GCP machine vs:
  * 1 CPU
  * 3.75GB RAM
  * 50-100 GB HDD
  * Ubuntu 16.04

```
export GOOGLE_PROJECT=docker-211106
docker-machine create --driver google \
  --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
  --google-machine-type n1-standard-1 \
  --google-zone europe-west1-b \
  --google-disk-size 75 \
  gitlab-host
eval $(docker-machine env gitlab-host)
docker-machine ls
```
open gce ports tcp:80, tcp:443 tcp:2222
```
gcloud compute firewall-rules create allow-80-http \
--allow tcp:80 \
--target-tags=docker-machine \
--description="Allow gitlab_container_http" \
--direction=INGRESS

gcloud compute firewall-rules create allow-https \
--allow tcp:443 \
--target-tags=docker-machine \
--description="Allow gitlab_container_https" \
--direction=INGRESS

gcloud compute firewall-rules create allow-ssh-2222 \
--allow tcp:2222 \
--target-tags=docker-machine \
--description="Allow gitlab_container_ssh" \
--direction=INGRESS
```


```
sudo docker run --detach \
    --hostname gitlab.example.com \
    --publish 443:443 --publish 80:80 --publish 2222:22 \
    --name gitlab \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
```
docker-compose up -d

2) Install Gitlab Runner:
```
docker run -d --name gitlab-runner --restart always \
-v /srv/gitlab-runner/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
gitlab/gitlab-runner:latest
```
3) Register gitlab runner:
`docker exec -it gitlab-runner gitlab-runner register`

#### Task  *
- integration gitlab-ci vs slack was made by adding webhook from slack to
`Project Settings > Integrations > Slack notifications`
link to slack chanel:
`https://devops-team-otus.slack.com/messages/C9M0Z3ZM2/`

- multi task [gitlab-runner register][99] automation via ` --non-interactive`:
```
docker run --rm -t -i -v /path/to/config:/etc/gitlab-runner --name gitlab-runner gitlab/gitlab-runner register \
  --non-interactive \
  --executor "docker" \
  --docker-image alpine:latest \
  --url "http://<YOUR-VM-IP>/" \
  --registration-token "PROJECT_REGISTRATION_TOKEN" \
  --description "docker-runner" \
  --tag-list "docker" \
  --run-untagged \
  --locked="false"
  ```

# hw18 Gitlab-ci CD

[100]: https://docs.gitlab.com/ee/ci/environments.html

1) start  gitlab-host vs gitlab:
```
docker-machine start gitlab-host
```
sudenly IP changed and we need to regenerate certificates:
`docker-machine regenerate-certs gitlab-host`

```
eval $(docker-machine env gitlab-host)
docker-machine ls
docker ps
```
2) Create new project via web interface in gitlab: `example2`
git remote add new:

```
git checkout -b gitlab-ci-2
git remote add gitlab2 http://35.195.73.169/homework/example2.git
```
register runner:
```
docker run --rm -t -i -v /srv/gitlab-runner/config:/etc/gitlab-runner --name gitlab-runner gitlab/gitlab-runner register \
  --non-interactive \
  --executor "docker" \
  --docker-image alpine:latest \
  --url "http://35.195.73.169" \
  --registration-token "token" \
  --description "docker-runner" \
  --tag-list "docker" \
  --run-untagged \
  --locked="false"
```

3) Dev enviroment, [Dynamic env][100]

# hw19 Prometheus

[101]: https://gist.github.com/Nklya/1752e865d2fab92402f6413cb00bf2ca
[102]: https://gist.github.com/Nklya/bfe2d817f72bc6376fb7d05507e97a1d
[103]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-21/add_prometheus
[104]: https://prometheus.io/docs/instrumenting/exporters/
[105]: https://github.com/prometheus/node_exporter
[106]: https://gist.github.com/Nklya/4b38f2ee1521252af80995a2bc667cb1
[107]: https://github.com/prometheus/blackbox_exporter
[108]: https://github.com/google/cloudprober
[109]: https://hub.docker.com/r/eses/mongodb_exporter/
[110]: https://gist.github.com/mpneuried/0594963ad38e68917ef189b4e6a269db
[111]: https://github.com/google/cloudprober/blob/master/Makefile

1) Install Prometheus:
 - Open ports in GCP
```
gcloud compute firewall-rules create prometheus-default --allow tcp:9090
gcloud compute firewall-rules create puma-default --allow tcp:9292
```
 - Create host in gcp:

```
export GOOGLE_PROJECT=docker-211106
# create docker host
docker-machine create --driver google \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
    --google-machine-type n1-standard-1 \
    --google-zone europe-west1-b \
    docker-host
```
 - Configure local env
```
eval $(docker-machine env docker-host)
docker run --rm -p 9090:9090 -d --name prometheus  prom/prometheus
docker-machine ip docker-host
```
 - Stop Prometeus and make docker prometheus image vs config for reddit microservices: `docker stop prometheus`
 - Configuration: `monitoring/prometheus/prometheus.yml`
 - Create Prometheus image:
 ```
export USER_NAME=lain0
docker build -t $USER_NAME/prometheus .
```
 - Build microservices Images via docker_build.sh:
```
for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done
```
 - Run microservices && prometheus: `docker-compose up -d`
 - [Exporters][104]
 - let's use [Node Exporter][105] for collecting metrics from docker-host
add new job to prometheus config and rebuild prometheus image
`docker build -t $USER_NAME/prometheus .`

- Push images to hub.docker.org
```
export USER_NAME=lain0
docker login
for i in ui post comment prometheus; do docker push $USER_NAME/$i; done
```
#### tasks *
 - [mongodb_exporter][109]
-web.listen-address - The listen address of the exporter (default: ":9104")
 - [blackbox_exporter][107] and [cloudprober][108]
 cloudprober is less documented for prometheus.yml jobs case so it's easier to use blackbox-exporter
 - [Makefiles][110]

 [Dockerhub account lain0](https://hub.docker.com/u/lain0/)

# hw20 Monitoring infrastructure Alerting
[112]: https://github.com/google/cadvisor
[113]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-23/add_cadvisor
[114]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-23/add_grafana
[115]: https://grafana.com/dashboards
[116]: https://github.com/express42/reddit/commit/e443f6ab4dcf25f343f2a50c01916d750fc2d096
[117]: https://github.com/express42/reddit/commit/d8a0316c36723abcfde367527bad182a8e5d9cf2
[118]: https://prometheus.io/docs/concepts/metric_types/
[119]: https://github.com/prometheus/client_ruby#counter
[120]: https://prometheus.io/docs/prometheus/latest/querying/functions/
[121]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-23/histogram_quantile
[122]: https://github.com/express42/reddit/commit/b2e73f1bcc121e9bae67a246dd9e3215a1079d6f
[123]: https://github.com/express42/reddit/commit/5e011209a92ba5749d6975a2b7cb35aad49e304e
[124]: https://devops-team-otus.slack.com/apps/A0F7XDUAZ-incoming-webhooks?next_id=0
[125]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-23/alertmanager_config.yml
[126]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-23/prom_alerts.yml
[127]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-23/add_prom_alerts
[128]: https://api.slack.com/incoming-webhooks

```
eval $(docker-machine env docker-host)
docker-machine ls
docker-machine ip docker-host
```
1) Docker Container Monitoring
Let's split `docker-compose.yml` into two files by:
  - for running microservices - `docker-compose.yml` runs:
  `docker-compose up -d`
  - for running monitoring `docker-compose-monitoring.yml` runs:
  `docker-compose -f docker-compose-monitoring.yml up -d`
2) [cAdvisor][112]
Rebuild prometheus vs cAdvisor job
```
export USER_NAME=username
docker build -t $USER_NAME/prometheus monitoring/prometheus/
```
Run containers:
```
docker-compose up -d
docker-compose -f docker-compose-monitoring.yml up -d
```
Open port tcp:8080 for cAdvisor
`gcloud compute firewall-rules create cadvisor-allow --allow tcp:8080`
3) Metrics Visualisations - [Grafana][115]
open port for grafana:
`gcloud compute firewall-rules create grafana-allow --allow tcp:3000`
build and run grafana container:
`docker-compose -f docker-compose-monitoring.yml up -d grafana`
4) Collecting application metrics && Monitoring APP

```
export USER_NAME=lain0
docker build -t $USER_NAME/prometheus monitoring/prometheus/
cd docker
docker-compose -f docker-compose-monitoring.yml down
docker-compose -f docker-compose-monitoring.yml up -d
```
[Histogram][118] and Percentile
rate(ui_request_count[1m])
rate(ui_request_count{http_status=~"^[200].*"}[1m])
rate(ui_request_count{http_status=~"^[45].*"}[1m])
histogram_quantile(0.95, sum(rate(ui_request_latency_seconds_bucket[5m])) by (le))
5) Collecting Buisness metrics
6) Alerting
 - build docker image for Prometheus Alertmanager
```
cd monitoring/alertmanager/
docker build -t lain0/alertmanager .
```
 - Add New service to docker-compose-monitoring.yml:

7) Alert rules
 - Build Prometheus image:
 ```
 docker build -t lain0/prometheus .
 ```
 - Recreate docker monitoring infrastructure:
 ```
 cd docker
 docker-compose -f docker-compose-monitoring.yml down
 docker-compose -f docker-compose-monitoring.yml up -d
 ```

8) Push all lain0/* repository to dockerhub
`make push-dockerhub`
