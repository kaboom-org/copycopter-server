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

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end