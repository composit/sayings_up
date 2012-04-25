source 'http://rubygems.org'

gem 'rails'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'
gem 'bson_ext'
gem 'mongoid'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'
  gem 'uglifier'
end

gem 'backbone-support'
gem 'bcrypt-ruby'
gem 'cancan'
gem 'capistrano'
gem 'jquery-rails'
gem 'rails-backbone'
gem 'rvm-capistrano'
gem 'ejs'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  gem 'capybara-webkit'
  gem 'factory_girl_rails'
  gem 'guard-jasmine-headless-webkit'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'spork'
  gem 'turn', :require => false
end

group :development, :test do
  #gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'foreman'
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :staging do
  gem 'passenger'
end
