#
# Cookbook Name:: mblwhoi_vhost_env
# Definition:: mblwhoi_vhost_env
# 

define :mblwhoi_vhost_env do

  # Include dependencies.
  include_recipe %w{mblwhoi_drupal_app apache2}
  
  # Params.  We list them here to make them explicit
  # and to make shortcut handles.
  root_dir = params[:root_dir]
  app_owner = params[:app_owner]
  app_group = params[:app_group]
  server_name = params[:server_name]

  # Optional parameters.
  docroot_dir = params[:docroot_dir] || "#{root_dir}/htdocs"
  apps_dir = params[:apps_dir] || "#{root_dir}/apps"
  use_default_apache_config = params[:use_default_apache_config] || true
  server_aliases = params[:server_aliases] || [server_name]
  drupal_apps = params[:drupal_apps] || []

  # Make root dir.
  directory "vhost root dir" do
    path root_dir
    mode "0775"
    owner app_owner
    group app_group
    recursive true
    action :create
  end

  # Make docroot dir.
  directory "docroot dir" do
    path docroot_dir
    mode "0775"
    owner app_owner
    group app_group
    action :create
  end

  # Make apps dir.
  directory "apps dir" do
    path apps_dir
    mode "0775"
    owner app_owner
    group app_group
    action :create
  end


  # Make apache config if using default config.
  web_app "#{server_name}" do
    template "default_mblwhoi_vhost.conf.erb"
    cookbook "mblwhoi_vhost_env"
    docroot docroot_dir
    server_name server_name
    server_aliases server_aliases
    only_if do
      use_default_apache_config == true
    end
  end

  # For each drupal app...
  drupal_apps.each do |app_id, app_config|

    # Create drupal app environment for the app.  (db, deployment dirs, code, config file).
    mblwhoi_drupal_app "drupal app #{app_id}" do
      app_name "%s" % app_config.fetch("app_name", app_id)
      app_dir "#{apps_dir}/%s" % app_config.fetch("app_dir", app_id)
      app_owner app_owner
      app_group app_group
    end

  end

end



