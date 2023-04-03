worker_processes 2
working_directory "/var/www/pf_app/current"
timeout 30

# Listen on a Unix data socket
listen "/var/www/pf_app/shared/tmp/sockets/.unicorn.sock"

# Path to unicorn PID file (the server's process ID)
pid "/var/www/pf_app/shared/tmp/pids/unicorn.pid"

stderr_path "/var/www/pf_app/shared/log/unicorn.log"
stdout_path "/var/www/pf_app/shared/log/unicorn.log"

# loading booster
preload_app true

# before starting processes
before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

# after finishing processes
after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end

