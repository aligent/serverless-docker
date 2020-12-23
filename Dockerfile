FROM node:alpine3.12

RUN mkdir /app /serverless /home/node/.config
RUN chown node:node /app /serverless /home/node/.config

RUN apk update && \
    apk add \
      sudo python3 py3-pip curl gnupg &&  \
    pip3 --no-cache-dir install --upgrade awscli

USER node
WORKDIR /serverless

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin:/serverless/node_modules/serverless/bin/

COPY --chown=node:node package.json ./
COPY --chown=node:node package-lock.json ./

RUN npm install && serverless.js --version

WORKDIR /app
USER root

COPY entrypoint.sh /docker-entrypoint.sh
RUN chmod 0755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

