# set :stage, :staging
# set :rails_env, 'staging'
# 
# server "191.101.81.240",
# user: "storebase",
# roles: %w{app db web},
# ssh_options: {
#   forward_agent: true,
#   auth_methods: %w(publickey)
# }
# 
# # set :nginx_server_name, 'staging.storebase.com'
# set :deploy_to, "/home/storebase/#{fetch(:application)}_staging"
# set :puma_conf, "#{shared_path}/config/puma.rb"
