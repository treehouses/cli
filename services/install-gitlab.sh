#!/bin/bash

  # runs gitlab on docker
#  docker run -d --hostname 192.168.86.47 -p 443:443 -p 80:80 -p 2222:22 --name gitlab -v /srv/gitlab/config:/etc/gitlab -v /srv/gitlab/logs:/var/log/gitlab -v /srv/gitlab/data:/var/opt/gitlab --privileged ulm0/gitlab

function install {
  # create service directory
  mkdir -p /srv/gitlab

  # create yml(s)
	# NEEDS REVIEW FOR FORMATTING
  {
    echo "version: '3.3'"
    echo "services:"
    echo "  gitlab:"
    echo "    ports:"
    echo "      - '443:443'"
    echo "      - '80:80'"
    echo "      - '2222:22'"
    echo "    volumes:"
    echo "      - '/srv/gitlab/config:/etc/gitlab'"
    echo "      - '/srv/gitlab/logs:/var/log/gitlab'"
    echo "      - '/srv/gitlab/data:/var/opt/gitlab'"
    echo "    privileged: true"
    echo "    image: ulm0/gitlab"
} > /srv/gitlab/gitlab.yml

  # create .env with default values

  # add autorun
  cat << EOF > /srv/gitlab/autorun
gitlab_autorun=true

if [ "$gitlab_autorun" = true ]; then
  treehouses services gitlab up
fi


EOF
}

# environment var
	# NEEDS REVIEW FOR ACCURACY
function uses_env {
  echo false
}

# add supported arch(es)
	# NEEDS TO BE CHANGED TO GITLAB
function supported_arches {
  echo "armv7l"
}

# add port(s)
	# NEEDS REVIEW FOR ACCURACY
function get_ports {
  echo "443"
  echo "80"
  echo "2222"
}

# add size (in MB)
	# NEEDS REVIEW FOR ACCURACY
function get_size {
  echo "1982"
}

# add description
function get_description {
  echo "GitLab is a web-based DevOps lifecycle tool that provides a Git-repository manager providing wiki, issue-tracking, continuous integration, and deployment pipeline features; all using an open-source license"
}

# add info
	# NEEDS REVIEW FOR FORMATTING
function get_info {
  echo "https://github.com/treehouses/gitlab"
  echo
  echo "\"GitLab <https://about.gitlab.com/> is an open core company which"
  echo "develops software for the software development lifecycle used by"
  echo "more than 100,000 organizations, 30 million estimated registered users,"
  echo "and has an active community of more than 3000 contributors.\""
}

# add svg icon
	# NEEDS TO BE CHANGED TO GITLAB
function get_icon {
  cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 210 194">
  <defs/>
  <g fill="none" fill-rule="evenodd">
    <path fill="#E24329" d="M105.0614 193.655l38.64-118.921h-77.28l38.64 118.921z"/>
    <path fill="#FC6D26" d="M105.0614 193.6548l-38.64-118.921h-54.153l92.793 118.921z"/>
    <path fill="#FCA326" d="M12.2685 74.7341l-11.742 36.139c-1.071 3.296.102 6.907 2.906 8.944l101.629 73.838-92.793-118.921z"/>
    <path fill="#E24329" d="M12.2685 74.7342h54.153l-23.273-71.625c-1.197-3.686-6.411-3.685-7.608 0l-23.272 71.625z"/>
    <path fill="#FC6D26" d="M105.0614 193.6548l38.64-118.921h54.153l-92.793 118.921z"/>
    <path fill="#FCA326" d="M197.8544 74.7341l11.742 36.139c1.071 3.296-.102 6.907-2.906 8.944l-101.629 73.838 92.793-118.921z"/>
    <path fill="#E24329" d="M197.8544 74.7342h-54.153l23.273-71.625c1.197-3.686 6.411-3.685 7.608 0l23.272 71.625z"/>
  </g>
</svg>
EOF
}
