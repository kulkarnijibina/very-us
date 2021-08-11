# frozen_string_literal: true

# Load DSL and Setup Up Stages
require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git
require 'capistrano/rails'
# require 'capistrano/rails/migrations'
require 'capistrano/bundler'
require 'capistrano/rvm'
require 'capistrano/puma'

require "whenever/capistrano"

install_plugin Capistrano::Puma
require 'capistrano/puma/workers'
require 'capistrano/puma/nginx'
# require 'capistrano/rails/migrations'
install_plugin Capistrano::Puma::Nginx
# require 'capistrano/sidekiq'
require 'capistrano/rails/assets'
require 'capistrano/sidekiq'
install_plugin Capistrano::Sidekiq  # Default sidekiq tasks
# Then select your service manager
install_plugin Capistrano::Sidekiq::Systemd
# set :whenever_command, "bundle exec whenever"
# require "whenever/capistrano"
# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
