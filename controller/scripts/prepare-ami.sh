#!/bin/bash -eux

SOURCE_DIR="$(cd "$(dirname "$0")"; pwd)"
KUBECTL_VERSION="v1.6.4"

export DEBIAN_FRONTEND=noninteractive
## Make sure we get the latest updates since the base image was released
apt-get update -q
apt-get upgrade -qy

apt-get install -y unzip curl
curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl > kubectl &&
  chmod +x kubectl && \
  mv kubectl /usr/local/bin

## Install systemd scripts for datacolet
install -o root -g root -m 0600 "${SOURCE_DIR}/systemd/apictl.service" /etc/systemd/system/apictl.service

echo "${KUBECTL_VERSION}" > /etc/kubernetes_community_ami_version

## Cleanup packer SSH key and machine ID generated for this boot
rm /root/.ssh/authorized_keys
rm /home/ubuntu/.ssh/authorized_keys
rm /etc/machine-id
touch /etc/machine-id
