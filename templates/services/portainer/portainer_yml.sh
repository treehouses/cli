#!/bin/bash

# create portainer.yml
mkdir -p /srv/portainer
{
  echo "version: '3.2'"
  echo
  echo "services:"
  echo "  agent:"
  echo "    image: portainer/agent"
  echo "    environment:"
  echo "      # REQUIRED: Should be equal to the service name prefixed by "tasks." when"
  echo "      # deployed inside an overlay network"
  echo "      AGENT_CLUSTER_ADDR: tasks.agent"
  echo "      # AGENT_PORT: 9001"
  echo "      # LOG_LEVEL: debug"
  echo "    volumes:"
  echo "      - /var/run/docker.sock:/var/run/docker.sock"
  echo "      - /var/lib/docker/volumes:/var/lib/docker/volumes"
  echo "    networks:"
  echo "      - agent_network"
  echo "    deploy:"
  echo "      mode: global"
  echo "      placement:"
  echo "        constraints: [node.platform.os == linux]"
  echo
  echo "  portainer:"
  echo "    image: portainer/portainer"
  echo "    command: -H tcp://tasks.agent:9001 --tlsskipverify"
  echo "    ports:"
  echo "      - \"8084:8084\""
  # echo "      - \"8000:8000\""
  echo "    volumes:"
  echo "      - portainer_data:/data"
  echo "    networks:"
  echo "      - agent_network"
  echo "    deploy:"
  echo "      mode: replicated"
  echo "      replicas: 1"
  echo "      placement:"
  echo "        constraints: [node.role == manager]"
  echo
  echo "networks:"
  echo "  agent_network:"
  echo "    driver: overlay"
  echo
  echo "volumes:"
  echo "  portainer_data:"
} > /srv/portainer/portainer.yml
