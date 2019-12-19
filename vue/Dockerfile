FROM node:alpine

LABEL maintainer="jhash147@gmail.com"

RUN npm install -g yarn --force

COPY package*.json yarn.lock /usr/src/app/
WORKDIR /usr/src/app
RUN yarn

COPY . /usr/src/app/

CMD ["yarn", "serve"]
