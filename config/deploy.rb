set :application, "sayings"
set :repository,  "git@github.com:composit/sayings_up.git"
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :use_sudo, false

require 'capistrano/ext/multistage'
set :stages, %w( staging murder )
set :default_stage, 'staging'

require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3-p374'
set :rvm_type, :system

require 'bundler/capistrano'

set :scm, :git

server 'murder', :app, :web, :db, primary: true

after 'deploy:restart', 'deploy:cleanup'
