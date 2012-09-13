rails_env = ENV['RAILS_ENV'] || 'production'
RAILS_ROOT = ENV['RAILS_ROOT'] || File.expand_path(File.dirname(File.dirname(File.dirname(__FILE__))))

working_directory RAILS_ROOT

worker_processes 4
preload_app true
timeout 30

working_directory RAILS_ROOT

stderr_path "log/unicorn_copycopter_#{rails_env}.log"

pid = RAILS_ROOT + "/tmp/pids/unicorn.pid"

listen "/tmp/unicorn_copycopter.sock", :backlog => 2048

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = RAILS_ROOT + "/Gemfile"
end

before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.
  old_pid = RAILS_ROOT + '/tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
