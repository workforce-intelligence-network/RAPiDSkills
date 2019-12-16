FROM node:alpine

LABEL maintainer="jhash147@gmail.com"

COPY . /usr/src/app/

WORKDIR /usr/src/app

RUN npm install -g yarn
RUN yarn

CMD ["yarn", "serve"]
