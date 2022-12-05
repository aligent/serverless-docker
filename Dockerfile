FROM node:16.11-alpine3.14

COPY .serverlessrc /home/node/.serverlessrc
RUN mkdir /app /serverless /home/node/.config /home/node/.serverless
RUN chown node:node /app /serverless /home/node/.config /home/node/.serverless /home/node/.serverlessrc

RUN apk update && \
    apk add \
      sudo python3 py3-pip bash shadow make g++ groff less &&  \
    pip3 --no-cache-dir install --upgrade awscli && \
    rm -rf /var/cache/apk/*

USER node
WORKDIR /serverless

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin:/serverless/node_modules/serverless/bin/
RUN echo 'alias serverless="serverless.js"' >> ~/.bashrc

COPY --chown=node:node package.json ./
COPY --chown=node:node package-lock.json ./

RUN npm ci && serverless.js --version
RUN ln /serverless/node_modules/serverless/bin/serverless.js /serverless/node_modules/serverless/bin/serverless

WORKDIR /app
USER root

COPY entrypoint.sh /docker-entrypoint.sh
RUN chmod 0755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

