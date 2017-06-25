source 'https://rubygems.org'

ruby '2.4.1'

gem 'rails', '~> 5.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'jquery-rails'
gem 'haml-rails'
gem 'bootstrap-sass'

gem 'turbolinks', '~> 5'
gem 'awesome_print'
gem 'acts-as-taggable-on'

# TODO: move this after we actually start populating live data
gem 'factory_girl_rails'
gem 'faker'

gem 'kaminari'
gem 'stamp'
gem 'geocoder'

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
  gem 'better_errors'
end

group :development do
  gem 'annotate'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec-rails'
end
