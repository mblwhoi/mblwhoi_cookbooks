#
# Cookbook Name:: mblwhoi_intranet_web_env
# Recipe:: default
#
# Main setup recipe for the MBLWHOI Intranet Web Environment.

# Include dependencies.
include_recipe %w{mblwhoi_vhost_env}

docroot_dir = "#{node[:mblwhoi_intranet_webserver][:root_dir]}/htdocs"

# Setup dla vhost environment via the mblwhoi_vhost_env definition.
# Make dla root dir.
mblwhoi_vhost_env "intranet vhost" do
  root_dir node[:mblwhoi_intranet_webserver][:root_dir]
  docroot_dir docroot_dir
  app_owner node[:mblwhoi_intranet_webserver][:app_owner]
  app_group node[:mblwhoi_intranet_webserver][:app_group]
  server_name node[:mblwhoi_intranet_webserver][:server_name]
  use_default_apache_config false # don't use the default apache config
  drupal_apps node[:mblwhoi_intranet_webserver][:drupal_apps]
end

# Make apache config.
web_app "#{node[:mblwhoi_intranet_webserver][:server_name]}" do
  template "mblwhoi_intranet_web.conf.erb"
  cookbook "mblwhoi_intranet_web_env"
  docroot docroot_dir
  server_name node[:mblwhoi_intranet_webserver][:server_name]
  server_aliases node[:mblwhoi_intranet_webserver][:server_aliases] || [node[:mblwhoi_intranet_webserver][:server_name]]
end
