set :application, "copycopter-server"
set :repository,  "git@github.com:kaboom-org/copycopter-server.git"

set :production_address, '50.57.69.95'
set :port, 22

role :web, production_address
role :app, production_address
role :db,  production_address, :primary => true

set :branch, 'master'
set :rails_env, 'production'
set :rvm_ruby_string, 'ruby-1.9.3@copycopter'
require "rvm/capistrano"

set :scm, :git
default_run_options[:pty] = true

set :user, "deploy"
set :auth_methods, "publickey"
set :use_sudo, false

set :deploy_to, "/var/www/#{application}/"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

desc "setup symlinks"
task :link_files do
  run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "ln -s #{shared_path}/config/rvmrc #{release_path}/.rvmrc"
end

# assets:precompile needs to know about s3 and the database
before "deploy:finalize_update", "link_files"

require 'capistrano-unicorn'