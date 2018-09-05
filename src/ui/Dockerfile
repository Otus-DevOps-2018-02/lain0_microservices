FROM alpine:3.7

# RUN apk add --no-cache ruby-bundler ruby-dev ruby-json alpine-sdk && gem install bundler --no-ri --no-rdoc
ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
# ADD Gemfile* $APP_HOME/
COPY . $APP_HOME/

# RUN bundle install
RUN apk --no-cache add ruby ruby-io-console \
    && apk --no-cache add --virtual build-dependencies ruby-dev build-base alpine-sdk && gem install bundler --no-ri --no-rdoc \
    && bundle install \
    && apk del build-dependencies \
    && rm -rf /usr/lib/ruby/gems/*/cache/* \
      /var/cache/apk/* \
      /tmp/* \
      /var/tmp/*

# ADD . $APP_HOME

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

CMD ["puma"]
