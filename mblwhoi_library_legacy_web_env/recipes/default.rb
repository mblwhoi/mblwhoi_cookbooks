#
# Cookbook Name:: mblwhoi_library_legacy_web_env
# Recipe:: default
#
# Main setup recipe for mblwhoi library website environment.

# Include dependencies.
include_recipe %w{mblwhoi_drupal_app mblwhoi_static_app}

# Include dependencies.
include_recipe %w{mblwhoi_vhost_env apache2}

# Setup library_legacy vhost environment via the mblwhoi_vhost_env definition.
# Make library_legacy root dir.
mblwhoi_vhost_env "library_legacy vhost" do
  root_dir node[:mblwhoi_library_legacy_webserver][:root_dir]
  app_owner node[:mblwhoi_library_legacy_webserver][:app_owner]
  app_group node[:mblwhoi_library_legacy_webserver][:app_group]
  server_name node[:mblwhoi_library_legacy_webserver][:server_name]
  use_default_apache_config true # use the default apache config
  drupal_apps node[:mblwhoi_library_legacy_webserver][:drupal_apps]
  static_apps node[:mblwhoi_library_legacy_webserver][:static_apps]
end

