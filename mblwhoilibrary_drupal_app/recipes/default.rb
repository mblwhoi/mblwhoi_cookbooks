#
# Cookbook Name:: test_dla_drupal_app
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Include recipe dependencies.
include_recipe "mblwhoi_drupal_app_env"

# Create dla drupal app environment
mblwhoi_drupal_app_env :mblwhoilibrary do
  capistrano_user node[:mblwhoilibrary_web][:capistrano][:user][:name]
  app_dir "#{node[:mblwhoilibrary_web][:apps_dir]}/mblwhoilibrary"
  symlink node[:mblwhoilibrary_web][:docroot]
end
