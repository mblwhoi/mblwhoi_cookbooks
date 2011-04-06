#
# Cookbook Name:: dla_web_env
# Recipe:: default
#
# Main setup recipe for dla.whoi.edu website environment.

# Make dla root dir.
directory "dla root dir" do
  path node[:dla_webserver][:root_dir]
  mode "0755"
  owner node[:dla_webserver][:app_owner]
  owner node[:dla_webserver][:app_owner]
  recursive true
  action :create
end


# Make docroot dir.
directory "dla docroot dir" do
  path node[:dla_webserver][:docroot_dir]
  mode "0755"
  owner node[:dla_webserver][:app_owner]
  owner node[:dla_webserver][:app_group]
  action :create
end

# Make apps dir.
directory "dla apps dir" do
  path node[:dla_webserver][:apps_dir]
  mode "0755"
  owner node[:dla_webserver][:app_owner]
  owner node[:dla_webserver][:app_group]
  action :create
end


# Make apache config.
web_app "#{node[:dla_webserver][:server_name]}" do
  template "dla_web.conf.erb"
  docroot node[:dla_webserver][:docroot_dir]
  server_name node[:dla_webserver][:server_name]
  server_aliases node[:dla_webserver][:server_aliases] || [node[:dla_webserver][:server_name]]
end


# For each dla_webserver drupal app...
node[:dla_webserver][:drupal_apps].each do |app_id, app_config|
  
  # Create drupal app environment for the app.  (db, deployment dirs, config file).
  mblwhoi_drupal_app "drupal app #{app_id}" do
    app_name "%s" % app_config.fetch("app_name", app_id)
    app_dir "#{node[:dla_webserver][:apps_dir]}/%s" % app_config.fetch("app_dir", app_id)
    symlink "#{node[:dla_webserver][:docroot_dir]}/%s" % app_config.fetch("symlink", app_id)
    app_owner "#{node[:dla_webserver][:app_owner]}"
    app_group "#{node[:dla_webserver][:app_group]}"
    app_repo "#{app_config[:repo]}"
    app_branch "%s" % [app_config[:branch] || "master"]
  end

end
