FROM ruby:3.0-alpine3.13

RUN mkdir -p /app
WORKDIR /app

RUN apk update \
	&& apk add --virtual build-dependencies build-base \
	&& apk add postgresql-dev \
	&& apk add --no-cache imagemagick-dev imagemagick

RUN gem update bundler

COPY Gemfile Gemfile.lock ./

RUN bundle install

RUN apk del build-dependencies

COPY . /app

EXPOSE 4000

CMD ["unicorn", "-c", "config/unicorn.rb", "-p", "4000"]


