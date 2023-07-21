# Number of worker depends on CPU core count
# If you use WEB_CONCURRENCY environmental variable(if env var is not set, default is 2)
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }
workers 2

# Min and Max threads per worker
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `environment` that Puma will run in.
rails_env = ENV.fetch("RAILS_ENV") { ENV['RACK_ENV'] || "production" }
environment rails_env

# Directories
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

# Set PIS location
pidfile "#{shared_dir}/pids/puma.pid"

# Set state location
state_path "#{shared_dir}/tmp/pids/puma.state"

# Set up socket location
bind "unix://#{shared_dir}/tmp/sockets/puma.sock"

# Set log files location
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end
