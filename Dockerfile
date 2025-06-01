FROM ruby:3.2.3-slim AS build

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    libpq5 \
    chromium \
    chromium-driver \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /myapp

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=3 && rm -rf ~/.bundle

COPY . .

RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

FROM ruby:3.2.3-slim AS final

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    libpq-dev \
    libpq5 \
    chromium \
    chromium-driver \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

WORKDIR /myapp

# 所有者を COPY 時点で設定
COPY --chown=rails:rails --from=build /usr/local/bundle /usr/local/bundle
COPY --chown=rails:rails --from=build /myapp /myapp

COPY entrypoint.sh /myapp/bin/docker-entrypoint
RUN chmod +x /myapp/bin/docker-entrypoint

USER rails:rails

ENTRYPOINT ["/bin/sh", "/myapp/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
