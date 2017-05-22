# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "ror_pro"
set :repo_url, "git@github.com:balashovmb/ror_pro.git"
set :deploy_user, 'deployer'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/ror_pro"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor/bundle"  

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
      #invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end