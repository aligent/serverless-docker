FROM node:15-alpine

RUN mkdir /app /serverless /home/node/.config
RUN chown node:node /app /serverless /home/node/.config

RUN apk add --update --no-cache py3-pip curl npm
RUN pip3 install --upgrade pip \
  && pip3 install awscli

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

