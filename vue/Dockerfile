FROM node:alpine

LABEL maintainer="jhash147@gmail.com"

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm config set -g production false && npm install --silent

COPY . .

ENV PORT 8080
EXPOSE 8080

CMD ["npx", "yarn", "serve"]
