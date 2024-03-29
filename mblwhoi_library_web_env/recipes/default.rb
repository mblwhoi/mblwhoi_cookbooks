#
# Cookbook Name:: mblwhoi_library_web_env
# Recipe:: default
#
# Main setup recipe for mblwhoi library website environment.
#
# We don't use the default mblwhoi vhost env definition because the library website has a slightly different configuration; it has no docroot dir.

# Include dependencies.
include_recipe %w{mblwhoi_drupal_app apache2}

# Make root dir.
directory "mblwhoi library root dir" do
  path node[:mblwhoi_library_webserver][:root_dir]
  mode "0775"
  owner node[:mblwhoi_library_webserver][:app_owner]
  group node[:mblwhoi_library_webserver][:app_group]
  recursive true
  action :create
end


# Note: we do not make a docroot dir for the mblwhoi library site.  The mblwhoi library drupal app becomes the docroot.

# Make apps dir.
directory "mblwhoi library apps dir" do
  path node[:mblwhoi_library_webserver][:apps_dir]
  mode "0775"
  owner node[:mblwhoi_library_webserver][:app_owner]
  owner node[:mblwhoi_library_webserver][:app_group]
  action :create
end


# Make apache config.
web_app "#{node[:mblwhoi_library_webserver][:server_name]}" do
  template "mblwhoi_library_web.conf.erb"
  docroot node[:mblwhoi_library_webserver][:docroot_dir]
  server_name node[:mblwhoi_library_webserver][:server_name]
  server_aliases node[:mblwhoi_library_webserver][:server_aliases] || [node[:mblwhoi_library_webserver][:server_name]]
end


# Create the mblwhoi library drupal app.  
app_id = "mblwhoi_library_home"
mblwhoi_drupal_app "mblwhoi library drupal app" do
  app_name "#{app_id}"
  app_dir "#{node[:mblwhoi_library_webserver][:apps_dir]}/%s" % app_id
  app_owner "#{node[:mblwhoi_library_webserver][:app_owner]}"
  app_group "#{node[:mblwhoi_library_webserver][:app_group]}"
end

