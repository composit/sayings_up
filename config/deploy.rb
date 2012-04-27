set :application, "sayings"
set :repository,  "git@github.com:composit/sayings_up.git"
set :user, 'root'
set :branch, 'master'
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true

require 'capistrano/ext/multistage'
set :stages, %w( staging )
set :default_stage, 'staging'

require 'rvm/capistrano'
set :rvm_type, :system
set :rvm_ruby_string, '1.9.3-p194'

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

server 'parasites', :app, :web, :db, primary: true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

#If you are using Passenger mod_rails uncomment this:
#namespace :deploy do
#  task :start do ; end
#  task :stop do ; end
#  task :restart, :roles => :app, :except => { :no_release => true } do
#    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#  end
#end

after 'deploy:update_code' do
  run "ln -nfs #{deploy_to}/shared/config/mongoid.yml #{release_path}/config/mongoid.yml"
  run "ln -nfs #{deploy_to}/shared/restart_server.sh #{release_path}/restart_server.sh"
  #run "ln -nfs #{deploy_to}/shared/log/ #{release_path}/log/"
  run "ln -nfs #{deploy_to}/shared/tmp/cache #{release_path}/tmp/cache"
  run "cd #{release_path} && bundle install --without test --without development"
  run "cd #{release_path} && ./restart_server.sh"
end
