FROM ruby:2.6.3-slim

ARG APP_NAME=phishin-chatbot

ENV APP_NAME=${APP_NAME} \
    INSTALL_PATH=/${APP_NAME} \
    IN_DOCKER=true

RUN apt-get update -qq && \
    apt-get install -y build-essential nodejs memcached && \
    apt-get clean

# Bundle install, copy app
WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install
COPY . .

EXPOSE 3000
CMD bundle exec puma -b tcp://0.0.0.0:3000
