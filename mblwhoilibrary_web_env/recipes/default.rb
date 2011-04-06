#
# Cookbook Name:: mblwhoilibrary_web_env
# Recipe:: default
#
# Main setup recipe for mblwhoilibrary.org website environment.

# Include dependencies.
include_recipe %w{mblwhoi_drupal_app mblwhoi_static_app}

# Make dla root dir.
directory "mblwhoilibrary root dir" do
  path node[:mblwhoilibrary_webserver][:root_dir]
  mode "0755"
  owner node[:mblwhoilibrary_webserver][:app_owner]
  owner node[:mblwhoilibrary_webserver][:app_owner]
  recursive true
  action :create
end


# Note: we do not make a docroot dir for the mblwhoilibrary site.  The mblwhoilibrary drupal app becomes the docroot.

# Make apps dir.
directory "mblwhoilibrary apps dir" do
  path node[:mblwhoilibrary_webserver][:apps_dir]
  mode "0755"
  owner node[:mblwhoilibrary_webserver][:app_owner]
  owner node[:mblwhoilibrary_webserver][:app_group]
  action :create
end


# Make apache config.
web_app "#{node[:mblwhoilibrary_webserver][:server_name]}" do
  template "mblwhoilibrary_web.conf.erb"
  docroot node[:mblwhoilibrary_webserver][:docroot_dir]
  server_name node[:mblwhoilibrary_webserver][:server_name]
  server_aliases node[:mblwhoilibrary_webserver][:server_aliases] || [node[:mblwhoilibrary_webserver][:server_name]]
end


# Create the mblwhoilibrary drupal app.  Note that we symlink this to the docrootdir.
app_id = "mblwhoilibrary"
mblwhoi_drupal_app "mblwhoilibrary drupal app" do
  app_name "#{app_id}"
  app_dir "#{node[:mblwhoilibrary_webserver][:apps_dir]}/%s" % app_id
  symlink "#{node[:mblwhoilibrary_webserver][:docroot_dir]}" 
  app_owner "#{node[:mblwhoilibrary_webserver][:app_owner]}"
  app_group "#{node[:mblwhoilibrary_webserver][:app_group]}"
  app_repo "git://github.com/adorsk-whoi/dla_cruises.git" # REPLACE THIS! JUST A STAND IN FOR NOW
  app_branch "master"
end

