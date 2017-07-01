FROM ruby:2.3

MAINTAINER boggs <hello@boggs.xyz>

RUN gem install bundler -v '1.15.1'

RUN mkdir /root/app
WORKDIR /root/app

COPY Gemfile .
COPY secrets.yml .
COPY app.rb .
RUN mkdir helpers
COPY helpers helpers

RUN bundle install --without development test

EXPOSE 4567
CMD ["ruby", "app.rb"]
