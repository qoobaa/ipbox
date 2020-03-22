# Stage: Builder
FROM ruby:2.6.5-alpine as Builder

ARG RAILS_ENV

ENV INSTALL_PATH=/app\
    SECRET_KEY_BASE=secret-key-base\
    RAILS_ENV=${RAILS_ENV}\
    RAILS_SERVE_STATIC_FILES=true\
    BUNDLE_WITHOUT="development test"

RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    git \
    imagemagick \
    nodejs-current \
    yarn \
    python2 \
    tzdata

WORKDIR $INSTALL_PATH

COPY Gemfile* $INSTALL_PATH/

RUN gem install bundler \
 && bundle config --global frozen 1 \
 && bundle config --local build.sassc --disable-march-tune-native \
 && bundle install -j4 --retry 3 \
 && rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY package.json yarn.lock $INSTALL_PATH/
RUN yarn install

COPY . .

RUN bundle exec rails assets:precompile

RUN rm -rf test node_modules app/assets vendor/assets lib/assets tmp/cache .docker .github
RUN mkdir -p $INSTALL_PATH/tmp/pids

# Stage: Final
FROM ruby:2.6.5-alpine

ARG ADDITIONAL_PACKAGES
ARG EXECJS_RUNTIME

ENV INSTALL_PATH=/app \
    RAILS_LOG_TO_STDOUT=true\
    RAILS_SERVE_STATIC_FILES=true\
    EXECJS_RUNTIME=Disabled

RUN apk add --update --no-cache\
    postgresql-client\
    imagemagick\
    $ADDITIONAL_PACKAGES\
    tzdata\
    file

RUN addgroup -g 1000 -S app \
 && adduser -u 1000 -S app -G app

RUN mkdir -p $INSTALL_PATH/storage \
 && chown app:app $INSTALL_PATH/storage

USER app

COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder --chown=app:app $INSTALL_PATH $INSTALL_PATH

WORKDIR $INSTALL_PATH

EXPOSE 3000

CMD bundle exec rails db:migrate 2>/dev/null\
 && bundle exec puma -C config/puma.rb
