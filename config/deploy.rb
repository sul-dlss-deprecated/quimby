set :application, 'quimby'
set :repo_url, 'https://github.com/sul-dlss/quimby.git'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/opt/app/quimby/quimby'

# Default value for linked_dirs is []
append :linked_dirs, 'log'

set :honeybadger_env, fetch(:stage)
