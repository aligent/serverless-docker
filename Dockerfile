FROM node:14

RUN mkdir /app
RUN mkdir /serverless
RUN chown node:node /app
RUN chown node:node /serverless

ARG DEBIAN_INTERACTIVE=noninteractive
RUN apt-get update && \
    apt-get --no-install-recommends --assume-yes --quiet \
        install sudo python-setuptools python-dev python-pip default-jre  &&  \
    rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install awscli

USER node
WORKDIR /serverless

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin:/serverless/node_modules/serverless/bin/

RUN curl -o- -L https://yarnpkg.com/install.sh | bash

COPY package.json ./
COPY package-lock.json ./
RUN npm install

RUN serverless.js --version

WORKDIR /app
USER root

COPY entrypoint.sh /docker-entrypoint.sh
RUN chmod 0755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

