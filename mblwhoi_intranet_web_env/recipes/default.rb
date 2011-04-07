#
# Cookbook Name:: mblwhoi_intranet_web_env
# Recipe:: default
#
# Main setup recipe for the MBLWHOI Intranet Web Environment.

# Include dependencies.
include_recipe %w{mblwhoi_drupal_app mblwhoi_static_app}

# Make intranet root dir.
directory "intranet root dir" do
  path node[:mblwhoi_intranet_webserver][:root_dir]
  mode "0755"
  owner node[:mblwhoi_intranet_webserver][:app_owner]
  owner node[:mblwhoi_intranet_webserver][:app_owner]
  recursive true
  action :create
end


# Make docroot dir.
directory "intranet docroot dir" do
  path node[:mblwhoi_intranet_webserver][:docroot_dir]
  mode "0755"
  owner node[:mblwhoi_intranet_webserver][:app_owner]
  owner node[:mblwhoi_intranet_webserver][:app_group]
  action :create
end

# Make apps dir.
directory "intranet apps dir" do
  path node[:mblwhoi_intranet_webserver][:apps_dir]
  mode "0755"
  owner node[:mblwhoi_intranet_webserver][:app_owner]
  owner node[:mblwhoi_intranet_webserver][:app_group]
  action :create
end


# Make apache config.
web_app "#{node[:mblwhoi_intranet_webserver][:server_name]}" do
  template "mblwhoi_intranet_web.conf.erb"
  docroot node[:mblwhoi_intranet_webserver][:docroot_dir]
  server_name node[:mblwhoi_intranet_webserver][:server_name]
  server_aliases node[:mblwhoi_intranet_webserver][:server_aliases] || [node[:mblwhoi_intranet_webserver][:server_name]]
end


# For each mblwhoi_intranet_webserver drupal app...
node[:mblwhoi_intranet_webserver][:drupal_apps].each do |app_id, app_config|
  
  # Create drupal app environment for the app.  (db, deployment dirs, code, config file).
  mblwhoi_drupal_app "drupal app #{app_id}" do
    app_name "%s" % app_config.fetch("app_name", app_id)
    app_dir "#{node[:mblwhoi_intranet_webserver][:apps_dir]}/%s" % app_config.fetch("app_dir", app_id)
    symlink "#{node[:mblwhoi_intranet_webserver][:docroot_dir]}/%s" % app_config.fetch("symlink_name", app_id)
    app_owner "#{node[:mblwhoi_intranet_webserver][:app_owner]}"
    app_group "#{node[:mblwhoi_intranet_webserver][:app_group]}"
    app_repo "#{app_config[:repo]}"
    app_branch "%s" % [app_config[:branch] || "master"]
  end

end



# For each mblwhoi_intranet_webserver static app...
node[:mblwhoi_intranet_webserver][:static_apps].each do |app_id, app_config|
  
  # Create static app environment for the app. (deploy dir, code)
  mblwhoi_static_app "drupal app #{app_id}" do
    app_name "%s" % app_config.fetch("app_name", app_id)
    app_dir "#{node[:mblwhoi_intranet_webserver][:apps_dir]}/%s" % app_config.fetch("app_dir", app_id)
    symlink "#{node[:mblwhoi_intranet_webserver][:docroot_dir]}/%s" % app_config.fetch("symlink_name", app_id)
    app_owner "#{node[:mblwhoi_intranet_webserver][:app_owner]}"
    app_group "#{node[:mblwhoi_intranet_webserver][:app_group]}"
    app_repo "#{app_config[:repo]}"
    app_branch "%s" % [app_config[:branch] || "master"]
  end

end
