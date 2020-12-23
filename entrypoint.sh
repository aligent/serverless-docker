#!/bin/bash
#set -x

APP_ROOT="/app"

chown -R node:node /home/node/.config
chown -R node:node /home/node/.serverless

cd $APP_ROOT

if [ "${1:-}" = "sls" ] || [ "${1:-}" = "serverless" ]; then
  shift
  exec sudo -u node /serverless/node_modules/serverless/bin/serverless.js "$@"
fi

exec sudo -u node "$@"

