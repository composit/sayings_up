source 'http://rubygems.org'

ruby '1.9.3'
gem 'rails', '~>3.2'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'
gem 'bson_ext', '~>1.6'
gem 'mongoid', '~>3.0'
gem 'thin', '~>1.4'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~>3.2'
  gem 'sass-rails', '~>3.2'
  gem 'uglifier', '~>1.2'
end

gem 'backbone-support', '~>0.2'
gem 'bcrypt-ruby', '~>3.0'
gem 'bourbon', '~>2.1'
gem 'cancan', '~>1.6'
gem 'capistrano', '~>2.12'
gem 'ejs', '~>1.0'
gem 'jquery-rails', '~>2.0'
gem 'rails-backbone', '~>0.7'
gem 'rvm-capistrano', '~>1.2'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  gem 'capybara-webkit', '~>0.12'
  gem 'database_cleaner', '~>0.8'
  gem 'factory_girl_rails', '~>3.5'
  gem 'guard-jasmine-headless-webkit', '~>0.3'
  gem 'guard-rspec', '~>1.2'
  gem 'guard-spork', '~>1.1'
  gem 'launchy', '~>2.1'
  gem 'rspec-rails', '~>2.11'
  gem 'spork', '~>0.9'
  gem 'turn', '~>0.9', :require => false
end

group :development, :test do
  gem 'foreman', '~>0.51'
  gem 'pry-rails', '~>0.1'
end

group :staging do
  gem 'passenger', '~>3.0'
end
