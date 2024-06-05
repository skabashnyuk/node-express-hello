# Install the app dependencies in a full Node docker image
FROM registry.access.redhat.com/ubi8/nodejs-18:latest

# Copy package.json, and optionally package-lock.json if it exists
COPY package.json package-lock.json* ./

# Install app dependencies
RUN \
  if [ -f package-lock.json ]; then npm ci; \
  else npm install; \
  fi

# Copy the dependencies into a Slim Node docker image
FROM quay.io/ksmster/ns-renovatenudge-pnqgz20x2mrsw/github-build-nudge-example/github-common-nodejs-parent@sha256:216a0fa731c335e849b93971fe4f22584931f943bc24aa1d992e0014fed5cc0d

# Install app dependencies
COPY --from=0 /opt/app-root/src/node_modules /opt/app-root/src/node_modules
COPY . /opt/app-root/src

ENV NODE_ENV production
ENV PORT 3001

CMD ["npm", "start"]