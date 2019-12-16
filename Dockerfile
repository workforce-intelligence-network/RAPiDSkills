FROM ruby:2.6.3

LABEL maintainer="jeanine@littleforestconsulting.com"

COPY . /usr/src/app/

WORKDIR /usr/src/app

# Ensure we install an up-to-date version of Node
# See https://github.com/yarnpkg/yarn/issues/2888
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  vim

RUN npm install -g yarn
RUN yarn install

WORKDIR /usr/src/app/vue

RUN yarn build

WORKDIR /usr/src/app

RUN bundle install

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
