FROM node

COPY dapp /opt/vulcan0x/dapp
COPY config /opt/vulcan0x/config
COPY graphql /opt/vulcan0x/graphql
COPY pg /opt/vulcan0x/pg
COPY src /opt/vulcan0x/src
COPY .babelrc /opt/vulcan0x/.babelrc
COPY package.json /opt/vulcan0x/package.json

WORKDIR /opt/vulcan0x
RUN npm install
