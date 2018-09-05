#!/bin/bash
# docker-machine.sh

install() {
    base=https://github.com/docker/machine/releases/download/v0.14.0 &&
      curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
      sudo install /tmp/docker-machine /usr/local/bin/docker-machine
}

completion(){
    base=https://raw.githubusercontent.com/docker/machine/v0.14.0
    for i in docker-machine-prompt.bash docker-machine-wrapper.bash docker-machine.bash
    do
      sudo wget "$base/contrib/completion/bash/${i}" -P /etc/bash_completion.d
    done
}

export GOOGLE_PROJECT=docker-211106

vm_new(){
    docker-machine create --driver google \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
    --google-machine-type n1-standard-1 \
    --google-zone europe-west1-b \
    docker-host
}


# open port in gce
gce_tcp9292_open(){
    gcloud compute firewall-rules create reddit-app \
        --allow tcp:9292 \
        --target-tags=docker-machine \
        --description="Allow PUMA connections" \
        --direction=INGRESS
}

# # export all bash functions:
# set -a
# source ./docker-machine.sh
# set +a
$1
