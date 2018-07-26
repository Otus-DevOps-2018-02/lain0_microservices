FROM alpine:3.7

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
# ADD Gemfile* $APP_HOME/
COPY . $APP_HOME/

# RUN mkdir -p /usr/local/etc \
#     && { \
#         echo 'install: --no-document'; \
#         echo 'update: --no-document'; \
#     } >> /usr/local/etc/gemrc
RUN apk --no-cache add ruby ruby-io-console \
    && apk --no-cache add --virtual build-dependencies ruby-dev ruby-bundler build-base \
    && bundle install && bundle clean --force\
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
