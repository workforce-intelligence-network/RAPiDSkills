FROM node:alpine

LABEL maintainer="jhash147@gmail.com"

RUN npm install -g yarn --force

COPY . /usr/src/app/
WORKDIR /usr/src/app
RUN yarn

CMD ["yarn", "serve"]
