# frozen_string_literal: true

server '52.2.94.174', user: 'ubuntu', roles: %w[web app db], primary: true
set :ssh_options, forward_agent: true, user: fetch(:user), keys: %w[~/.ssh/id_rsa]
set :rails_env, :staging
set :rack_env,  :staging
set :stage,     :staging
set :branch,    :staging
 