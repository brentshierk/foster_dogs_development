source 'https://rubygems.org'

ruby '2.6'

gem 'rails', '~> 5.2.2'
gem 'pg'
gem 'puma'
gem 'sass-rails'
gem 'uglifier'

gem 'jquery-rails'
gem 'haml-rails'
gem 'bootstrap-sass'

gem 'turbolinks', '~> 5'
gem 'awesome_print'

gem 'faker'

gem 'kaminari'
gem 'stamp'
gem 'geocoder'

gem 'searchkick'
gem 'bonsai-elasticsearch-rails'

gem 'mailchimp-api', require: 'mailchimp'

gem 'rollbar'

gem 'paranoia'

gem 'faraday'

gem 'redis-rails'
gem 'sidekiq'

gem 'dalli'

gem 'oj'
gem 'devise'

group :production, :staging do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'guard'
  gem 'guard-livereload'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'binding_of_caller'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'better_errors'
  gem 'rails-controller-testing'
end

group :development do
  gem 'bullet'
  gem 'annotate'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'rspec-rails'
end
