FROM ruby:2.7.0-alpine

RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      g++ \
      git \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev

RUN gem install bundler -v 2.1.4

WORKDIR /app

COPY Gemfile Gemfile.lock ./

COPY . ./

RUN bundle check || bundle install

RUN gem install rails

ENTRYPOINT ["ruby", "socket_client.rb"]