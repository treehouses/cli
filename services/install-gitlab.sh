#!/bin/bash

run_gitlab

function run_gitlab {
  docker run -d --hostname 192.168.86.47 -p 443:443 -p 80:80 -p 2222:22 --name gitlab -v /srv/gitlab/config:/etc/gitlab -v /srv/gitlab/logs:/var/log/gitlab -v /srv/gitlab/data:/var/opt/gitlab --privileged ulm0/gitlab
}
