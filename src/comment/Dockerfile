FROM alpine:3.7

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
# COPY . $APP_HOME/

RUN apk --no-cache add ruby ruby-io-console \
    && apk --no-cache add --virtual build-dependencies ruby-dev ruby-bundler build-base \
    && bundle install && bundle clean --force \
    && apk del build-dependencies \
    && rm -rf /usr/lib/ruby/gems/*/cache/* \
          /var/cache/apk/* \
          /tmp/* \
          /var/tmp/*

ADD . $APP_HOME

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
