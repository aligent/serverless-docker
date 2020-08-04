FROM node:14

RUN mkdir /app
RUN chown node:node /app

ARG DEBIAN_INTERACTIVE=noninteractive
RUN apt-get update && \
    apt-get --no-install-recommends --assume-yes --quiet \
        install sudo python-setuptools python-dev python-pip &&            \
    rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install awscli

USER node
WORKDIR /app

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin

RUN curl -o- -L https://yarnpkg.com/install.sh | bash

RUN npm install -g serverless@1.78.0
RUN serverless --version

USER root

COPY entrypoint.sh /docker-entrypoint.sh
RUN chmod 0755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

