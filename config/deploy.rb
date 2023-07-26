# config valid for current version and patch releases of Capistrano
lock "~> 3.17.3"

# Default tasks
set :application, 'storebase'
set :repo_url, 'git@github.com:Naoyuk/storebase.git'
set :branch, 'main'
set :deploy_to, "/home/storebase/#{fetch(:application)}"
set :linked_files, %w(.env config/master.key)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads public/packs node_modules)
set :keep_releases, 5

# capistrano-rails
set :rails_env, 'production'
# set :log_level, :debug

# capistrano-rbenv
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

# capistrano-puma
set :puma_conf, "#{shared_path}/config/puma.rb"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_stdout_log, "#{shared_path}/log/puma.stdout.log"
set :puma_stderr_log, "#{shared_path}/log/puma.stderr.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_threads, [0, 5]
set :puma_workers, 2
