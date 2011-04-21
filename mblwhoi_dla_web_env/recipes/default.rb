#
# Cookbook Name:: mblwhoi_dla_web_env
# Recipe:: default
#
# Main setup recipe for the DLA website environment.

# Include dependencies.
include_recipe %w{mblwhoi_vhost_env}

# Define docroot dir.
docroot_dir = "#{node[:mblwhoi_dla_webserver][:root_dir]}/htdocs" 

# Setup dla vhost environment via the mblwhoi_vhost_env definition.
# Make dla root dir.
mblwhoi_vhost_env "dla vhost" do
  root_dir node[:mblwhoi_dla_webserver][:root_dir]
  docroot_dir docroot_dir
  app_owner node[:mblwhoi_dla_webserver][:app_owner]
  app_group node[:mblwhoi_dla_webserver][:app_group]
  server_name node[:mblwhoi_dla_webserver][:server_name]
  use_default_apache_config false # don't use the default apache config
  drupal_apps node[:mblwhoi_dla_webserver][:drupal_apps]
  static_apps node[:mblwhoi_dla_webserver][:static_apps]
end

# Make apache config.
web_app "#{node[:mblwhoi_dla_webserver][:server_name]}" do
  template "mblwhoi_dla_web.conf.erb"
  cookbook "mblwhoi_dla_web_env"
  docroot docroot_dir
  server_name node[:mblwhoi_dla_webserver][:server_name]
  server_aliases node[:mblwhoi_dla_webserver][:server_aliases] || [node[:mblwhoi_dla_webserver][:server_name]]
end

