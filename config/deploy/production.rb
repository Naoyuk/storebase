set :stage, :production
set :rails_env, 'production'

server "storebase.naoyuki-ishida.com",
user: "storebase",
roles: %w{app db web},
ssh_options: {
  forward_agent: true,
  auth_methods: %w(publickey)
}

set :nginx_server_name, '_'
# set :deploy_to, "/home/storebase/#{fetch(:application)}_production"
set :puma_conf, "#{shared_path}/config/puma.rb"
