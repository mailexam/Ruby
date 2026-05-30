FROM ruby:4.0-slim-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential git libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENV PORT=3000
ENV RAILS_ENV=development

EXPOSE 3000

CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
