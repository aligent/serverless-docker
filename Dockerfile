ARG NODE_TAG
FROM node:${NODE_TAG}

COPY .serverlessrc /home/node/.serverlessrc
RUN mkdir /app /serverless /home/node/.config /home/node/.serverless
RUN chown node:node /app /serverless /home/node/.config /home/node/.serverless /home/node/.serverlessrc

RUN apk update && \
    apk add \
      sudo bash shadow make g++ groff less git openssh awscli \
    rm -rf /var/cache/apk/*

USER node
WORKDIR /serverless

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin:/serverless/node_modules/serverless/bin/

COPY --chown=node:node package.json ./
COPY --chown=node:node package-lock.json ./

RUN npm ci && serverless.js --version
RUN ln /serverless/node_modules/serverless/bin/serverless.js /serverless/node_modules/serverless/bin/serverless

WORKDIR /app
USER root

COPY entrypoint.sh /docker-entrypoint.sh
RUN chmod 0755 /docker-entrypoint.sh

EXPOSE 9229
ENTRYPOINT ["/docker-entrypoint.sh"]

