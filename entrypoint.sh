#!/bin/bash
#set -x

APP_ROOT="/app"

DOCKER_UID=`stat -c "%u" $APP_ROOT`
DOCKER_GID=`stat -c "%g" $APP_ROOT`

INCUMBENT_USER=`getent passwd $DOCKER_UID | cut -d: -f1`
INCUMBENT_GROUP=`getent group $DOCKER_GID | cut -d: -f1`

#echo "Docker: uid = $DOCKER_UID, gid = $DOCKER_GID"
#echo "Incumbent: user = $INCUMBENT_USER, group = $INCUMBENT_GROUP"

userdel node
groupadd -g ${DOCKER_GID} node
useradd -g ${DOCKER_GID} --home-dir /home/node -s /bin/bash -u ${DOCKER_UID} node

chown -R node:node /home/node/.config
chown -R node:node /home/node/.serverless
chown -R node:node /home/node/.serverlessrc
chown -R node:node /home/node/.aws
chown -R node:node /home/node/.npm

cd $APP_ROOT

if [ "${1:-}" = "sls" ] || [ "${1:-}" = "serverless" ]; then
  shift
  exec sudo -u node /serverless/node_modules/serverless/bin/serverless.js "$@"
fi

exec sudo -u node "$@"

