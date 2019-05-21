FROM ruby:2.6.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
COPY . /myapp
RUN cd ./myapp && bundle install
