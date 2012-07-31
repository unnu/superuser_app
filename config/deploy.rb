# RVM bootstrap
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, 'ruby-1.9.2-p290'

# Bundler
require "bundler/capistrano"

# whenever
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

# Rails 3.1 asset pipelining
load "deploy/assets"

set :application, "superuser"
set :deploy_to, "/home/superuser/app"
set :user, "superuser"
set :use_sudo, false

set :repository,  "git@github.com:unnu/superuser_app.git"
set :scm, :git

set :deploy_via, :remote_cache
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

role :web, "superuser.app"
role :app, "superuser.app"
role :db,  "superuser.app", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
        require './config/boot'
        require 'airbrake/capistrano'
