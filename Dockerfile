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
FROM quay.io/ksmster/ns-gitlabnudge-ojpooxihws7c0/build-nudge-example/common-nodejs-parent@sha256:89c017a14198cf45aeb8a24f4cbf429e6e14c18289f0eebf8a3b0a8687b1bd05

# Install app dependencies
COPY --from=0 /opt/app-root/src/node_modules /opt/app-root/src/node_modules
COPY . /opt/app-root/src

ENV NODE_ENV production
ENV PORT 3001

CMD ["npm", "start"]