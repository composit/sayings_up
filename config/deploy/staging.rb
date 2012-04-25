set :deploy_to, '/var/www/dev/sayings_up'
set :rails_env, 'staging'

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

