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

## hw15 Docker Images Microservices
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

## hw16 Docker-compose networking docker image testing
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

## hw17 GitlabCI Continuos Integration

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

## hw18 Gitlab-ci CD

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

## hw19 Prometheus

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

## hw20 Monitoring infrastructure Alerting
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
 - build docker image for Prometheus Alertmanager component
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
gcloud compute firewall-rules create alertmanager-allow --allow tcp:9093
```

8) Push all lain0/* repository to dockerhub
`make push-dockerhub`

 [Dockerhub account lain0](https://hub.docker.com/u/lain0/)

## hw21 Logging ELK

[129]: https://github.com/express42/reddit/tree/logging
[130]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-25/create_docker-machine
[131]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-25/docker-compose-logging1.yml
[132]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-25/fluent.conf
[133]: https://docs.docker.com/config/containers/logging/fluentd/
[134]: https://docs.fluentd.org/v0.12/articles/in_forward
[135]: https://docs.fluentd.org/v0.12/articles/out_copy
[136]: https://gist.githubusercontent.com/chromko/af9ece71017df606cef3ee6229d5a4d5/raw/21672e5326201c9ae3e8d705a9c8e64a4591d90d/gistfile1.txt
[137]: https://gist.githubusercontent.com/chromko/af76301bed8c811c7110033d8d647109/raw/c88c65fa773770dab8a91065c3fe2d94556fb1d9/gistfile1.txt

stop all containers:
```
docker kill $(docker ps -q)
```

1) make docker-host logging:
```
export GOOGLE_PROJECT=docker-211106
docker-machine create --driver google \
--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
--google-machine-type n1-standard-1 \
--google-open-port 5601/tcp \
--google-open-port 9292/tcp \
--google-open-port 9411/tcp \
logging
```

```
eval $(docker-machine env logging)
docker-machine ls
docker-machine ip logging
```
2) Build new images vs microservices:
```
mv src src2
git clone --single-branch -b logging https://github.com/express42/reddit/tree/logging src
export USER_NAME=lain0
for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done
```
3) Docker-Containers Logging vs `docker-compose-logging.yml`
4) Fluentd
 - Build Fluentd image:
```
export USER_NAME=lain0
docker build -t $USER_NAME/fluentd .
```
5) Run microservices && EFK
```
cd docker
docker-compose -f docker-compose-logging.yml -f docker-compose.yml up -d
docker ps
```
open ports:
```
gcloud compute firewall-rules create fluentd-allow --allow tcp:24224
gcloud compute firewall-rules create fluentd-allow --allow tcp:24224
```
docker-compose logs -f post
restart vs zipkin service:
```
docker-compose -f docker-compose-logging.yml -f docker-compose.yml down
docker-compose -f docker-compose-logging.yml -f docker-compose.yml up -d
```
[Fluentd logging driver][133]

6) Kibana
add json Filters to fluentd.conf and rebuild fluentd image  and restart containers
```
docker build -t $USER_NAME/fluentd logging/fluentd/
cd docker && docker-compose -f docker-compose-logging.yml up -d
```

# hw22 Kubernetes

[138]: https://gist.githubusercontent.com/chromko/d90b18ed9fac3eba9d19a72deec5d346/raw/dd4261dfb8e1b190f9b7a3d2dca6ce349976052b/gistfile1.txt
[139]: https://github.com/kelseyhightower/kubernetes-the-hard-way

[kubernetes-the-hard-way][139]


# TEST k8s applications `kubectl apply -f ./kubernetes/reddit` :
```
kubectl apply -f comment-deployment.yml
kubectl apply -f ui-deployment.yml
kubectl apply -f post-deployment.yml
kubectl apply -f mongo-deployment.yml
```

```
kubectl get pods -o wide
```

# hw23 Kubernetes Controllers Security
[140]: https://kubernetes.io/docs/tasks/tools/install-kubectl/
[141]: https://www.virtualbox.org/wiki/Downloads
[142]: https://raw.githubusercontent.com/express42/otus-snippets/e7b0bc08c47a77709d313cfcbbaa3f9ed4b19340/k8s-controllers/minikube-install-linux
[143]: https://raw.githubusercontent.com/express42/otus-snippets/e7b0bc08c47a77709d313cfcbbaa3f9ed4b19340/k8s-controllers/ui-deployment.yml
[144]: https://gist.githubusercontent.com/chromko/0a120bc15784da4ef19f82f32f0b049e/raw/b8d709c06dfa7c6facad52ad4c3931e62e61d305/gistfile1.txt
[145]: https://raw.githubusercontent.com/express42/otus-snippets/e7b0bc08c47a77709d313cfcbbaa3f9ed4b19340/k8s-controllers/comment-deployment-with-db.yml
[146]: https://raw.githubusercontent.com/express42/otus-snippets/e7b0bc08c47a77709d313cfcbbaa3f9ed4b19340/k8s-controllers/mongo-deployment-with-volume.yml
[147]: https://raw.githubusercontent.com/express42/otus-snippets/e7b0bc08c47a77709d313cfcbbaa3f9ed4b19340/k8s-controllers/comment-service.yml
[148]: https://raw.githubusercontent.com/express42/otus-snippets/e7b0bc08c47a77709d313cfcbbaa3f9ed4b19340/k8s-controllers/mongodb-service.yml
[149]: https://raw.githubusercontent.com/express42/otus-snippets/e7b0bc08c47a77709d313cfcbbaa3f9ed4b19340/k8s-controllers/comment-mongodb-service.yml
[150]: https://raw.githubusercontent.com/express42/otus-snippets/e7b0bc08c47a77709d313cfcbbaa3f9ed4b19340/k8s-controllers/ui-deployment-with-env.yml
[151]: https://console.cloud.google.com/home/dashboard?project=reddit-kubernates&authuser=1

1) Install kubectl and Minukube
```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.28.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
```
2) Run Minukube Cluster:
```
minikube start
```
3) Kubectl:
- k8s node list
```
kubectl get nodes
```
- k8s context `~/.kube/config`:
    - cluster - API-server
    - user - user to connect to cluster
    - namespace
- cluster:
    - server - kubernetes API server's address
    - certificate-authority - root certificate
  name - identification name in config file
- user: auth credentials
    - username + password (Basic Auth
    - client key + client certificate
    - token
    - auth-provider config (GCP)
  name - identification name in config file
- context:
    - cluster - cluste rname
    - user - user name
    - namespace
  name
4) Kubectl configure:
- Create cluster:
```
kubectl config set-cluster ... cluster_name
```
- Create credentials:
```
kubectl config set-credentials ... user_name
```
- Create context:
```
kubectl config set-context context_name \
  --cluster=cluster_name \
  --user=user_name
```
- Use context:
```
kubectl config use-context context_name
```
- Know current context:
```
kubectl config current-context
```
- All context list
```
kubectl config get-contexts
```
5) Run application:
6) Deployment
6.1) [ui deployment][143]
- Run ui-component:
```
{
cd kubernetes/reddit
kubectl apply -f ui-deployment.yml
}
```
- list replics:
```
kubectl get deployment
```
- list ui pods:
```
kubectl get pods --selector component=ui
```
- port forwarding:
```
kubectl port-forward <pod-name> 8080:9292
```
```
curl localhost:9292/healthcheck
```
6.2) [Comment deployment][144]
```
{
cd kubernetes/reddit
kubectl apply -f comment-deployment.yml
kubectl get deployment
kubectl get pods --selector component=comment
}
```
- port forwarding:
```
kubectl port-forward <pod-name> 8181:9292
curl localhost:8181/healthcheck
```
6.3) Post deployment
- Run post-component:
```
{
cd kubernetes/reddit
kubectl apply -f post-deployment.yml
kubectl port-forward <pod-name> 8282:5000
curl localhost:8282/healthcheck
}
```
6.4) [Mongo deployment][146]
- mount volume outside container
6.5) Services
- make comment service available by name from any pods by adding it's to services:
```
kubectl apply -f comment-service.yml
```
- list endpoints vs somponent comment
```
kubectl describe service comment | grep Endpoints
kubectl exec -ti <pod-name> nslookup comment
```
```
kubectl apply -f post-service.yml
kubectl apply -f mongo-service.yml
kubectl apply -f comment-mongodb-service.yml
kubectl apply -f post-mongodb-service.yml
```

minikube service ui
```
minikube service list
```
7) Namespaces
- default - vs local namespace only
- kube-system - objects made by k8s for it's own
- kube-public - global objects visible from al cluster

```
kubectl get all -n kube-system
kubectl get all -n kube-system --selector k8s-app=kubernetes-dashboard
```
8) Dashboard
open dashboard:
```
minikube service kubernetes-dashboard -n kube-system
```
9) Create dev namespace
```
kubectl apply -f dev-namespace.yml
```
run app in dev namespace:
```
kubectl apply -f ui-deployment.yml -n dev
minikube service ui -n dev
```
10) Google Kubernetes Engine.
- In web browser [create kubernetes cluster][151]
- Connect to the cluster:
```
gcloud container clusters get-credentials gke-cluster1 --zone europe-west1-d --project reddit-kubernates
```
- know kubernetes current-context
```
kubectl config current-context
```
11) Deploy Reddit to GKE:
- create namespace dev:
```
kubectl apply -f ./kubernetes/reddit/dev-namespace.yml
```
- deploy reddit in namespace dev
```
kubectl apply -f ./kubernetes/reddit/ -n dev
```
- create firewall-rules to open ports in web browser
- see project firewall-rules
```
gcloud compute firewall-rules list --filter network=default --filter gke-cluster1
```
```
kubectl describe service ui -n dev |grep NodePort
```

[152]: http://35.240.30.72:32092/

[gke_link:32092][152]

[153]: https://raw.githubusercontent.com/express42/otus-snippets/e7b0bc08c47a77709d313cfcbbaa3f9ed4b19340/k8s-controllers/kubectl-create-clusterrolebinding

12) Security:
- open locally http://127.0.0.1:ui:8001
```
kubectl proxy
```
- RBAC authorization requires higher ClusterRole access rights, we can assign role `cluster-admin`

```
kubectl create clusterrolebinding kubernetes-dashboard  --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
```

# hw24 Kubernetes Network Storage
[154]: https://kubernetes.io/docs/tutorials/services/
[155]: https://gist.githubusercontent.com/chromko/487944706c6c438a7049bbcdae62d5c8/raw/ca6c04158888ecd0ab3a51459a701c04ac9996d3/gistfile1.txt
[156]: https://gist.githubusercontent.com/chromko/6d81bb41fe4c53e68fbff1275bab3fdb/raw/b911965be9c5ddf4e077d147701d89426bf94317/gistfile1.txt
[157]: https://gist.githubusercontent.com/chromko/c4cc151951fba9bb7481539e64bf93fc/raw/b3acc55ca3de3349a7511d75488606075503919b/gistfile1.txt
[158]: https://console.cloud.google.com/networking/routes/
[159]: https://gist.githubusercontent.com/chromko/831d9466f5100bc2f6556091739a4e32/raw/6364f1339453d701e7b7fa8d30bcbe8af791ef1d/gistfile1.txt
[160]: https://gist.githubusercontent.com/chromko/a1886f32e4df7adbfc30f2d796415ee5/raw/d970a123cdf85a512fac4a363dbcd756a7be8e37/gistfile1.txt
[161]: https://gist.githubusercontent.com/chromko/ffc6c3f948520fad2ded3c41b392250f/raw/28d804b60da6ecdff53fd2a20d847877c27c2089/gistfile1.txt
[162]: https://gist.githubusercontent.com/chromko/f331ea52db3a5aef2b13bc34ebeb7e35/raw/541e44393d5a89440b61334cbb981a9265daf92b/gistfile1.txt
[163]: https://gist.githubusercontent.com/chromko/cbf98525f8d8a29ca0882b7a4c495278/raw/178e0a2c7fd7d6feb64eaecbb32e75e76297b218/gistfile1.txt
[164]: https://console.cloud.google.com/compute/disks
[165]: https://gist.githubusercontent.com/chromko/18a31a48c91e4279d9a316d053832502/raw/c5e2e55a4375a8e6446427d4dc78892b014380c8/gistfile1.txt
[166]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-30/mongo-claim.yml
[167]: https://gist.githubusercontent.com/vitkhab/93f2e55054bdfd270e1516eccb36087d/raw/d63752c3751d1d25d42da2f2e64a2bd5426800fc/mongo-deployment.yml
[168]: https://gist.githubusercontent.com/chromko/4b10311b4470dd18770eda02179e43b2/raw/ea2af8a63cc527281e8e14c144726127a0941a2b/gistfile1.txt
[169]: https://raw.githubusercontent.com/express42/otus-snippets/master/hw-30/mongo-claim-dynamic.yml
[170]: https://gist.githubusercontent.com/vitkhab/820cc6338912514a7be23127be2726f4/raw/36f59db420ee5da941b0602b86b0550ac68be181/mongo-deployment.yml

- Ingress Controller
1) [Service][154]: - describe `endpoints`
service:
  type:
    - nodePort - source NAT’d
    - LoadBalancer - source NAT’d and uses LoadBalancer
    - ClusterIP - never source NAT’d, awailable only inside cluster or by kube-proxy, this type is by default
    - ExternalName - cluster external resourse

ClusterIP - virtual IP addeess, only for work inside cluster
```
kubectl get services -n dev
```
2) Kube-dns uses plugin - kube-dns POD
- lets try to turn off kube-dns-autoscaler and kube-dns to see pods can't resolve
```
kubectl scale deployment --replicas 0 -n kube-system kube-dns-autoscaler
kubectl scale deployment --replicas 0 -n kube-system kube-dns
```
- enshure pods can't resolve
```
kubectl get pods -o wide -n dev
kubectl exec -ti -n dev pods_name ping comment
```
- set kube-dns-autoscaler and kube-dns to 1
```
kubectl scale deployment --replicas 1 -n kube-system kube-dns-autoscaler
```
- network routes:
```
gcloud compute routes list --filter gke
```
- LoadBalancer
```
kubectl apply -f ui-service.yml -n dev
kubectl get service  -n dev --selector component=ui
```
http://node_ip:31861/
- Ingress uses Ingress Controller plugin (POD)
make ingress for ui service:
```
kubectl apply -f ui-ingress.yml -n dev
```

```
kubectl get ingress -n dev
```
change type back to NodePort:
```
kubectl apply -f ui-service.yml -n dev
```
make Ingress Controller act as classic web
```
kubectl apply -f ui-ingress.yml -n dev
```
- Secret
```
kubectl get ingress -n dev
```
make certificate:
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=35.227.193.11"

```
upload certificate
```
kubectl create secret tls ui-ingress --key tls.key --cert tls.crt -n dev
```
test
```
kubectl describe secret ui-ingress -n dev
```
disable TLS Termination:
```
kubectl apply -f ui-ingress.yml -n dev
```
- TLS
- LoadBalancer Service
- Network Policies
    - know cluster name:
```
gcloud beta container clusters list
```
    - enable NetworkPolicy for GKE:
```
export CLUSTER_NAME=gke-cluster1
gcloud beta container clusters update $CLUSTER_NAME \
--zone=europe-west1-d --update-addons=NetworkPolicy=ENABLED
gcloud beta container clusters update $CLUSTER_NAME \
--zone=europe-west1-d  --enable-network-policy
```
- Volumes
    - create new GCP drive for mongoDB POD:
```
gcloud compute disks create --size=25GB --zone=europe-west1-d reddit-mongo-disk
```
    - add, mount new volume for mondoDB POD:
```
kubectl apply -f mongo-deployment.yml -n dev
```
    - delete deployment and recreate POD, to see volume is ok after POD recreation
```
kubectl delete deploy mongo -n dev
kubectl apply -f mongo-deployment.yml -n dev
```
- PersistentVolumes
```
kubectl apply -f mongo-volume.yml -n dev
```
- PersistentVolumeClaims - request for volume, PersistentVolumes
```
kubectl apply -f mongo-claim.yml -n dev
```
default PVC
```
kubectl describe storageclass standard -n dev
```
    - add new PVC to mongo POD:
```
kubectl apply -f mongo-deployment.yml -n dev
```
- StorageClass
add fast ssd starage for mongodb volume
```
kubectl apply -f storage-fast.yml -n dev
```
- PVC + StorageClass
add StorageClass to cluster
```
kubectl apply -f mongo-claim-dynamic.yml -n dev
```
connect PVC to our pods
```
kubectl apply -f mongo-deployment.yml -n dev
```
list all PersistentVolumes
```
kubectl get persistentvolume -n dev
```
