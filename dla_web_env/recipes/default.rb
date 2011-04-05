#
# Cookbook Name:: dla_web_env
# Recipe:: default
#
# Main setup recipe for dla.whoi.edu website environment.

# Include recipe dependencies.
# Dependencies will include sub-dependencies in turn.
include_recipe %w{mblwhoi_drupal mblwhoi_capistrano}

# Install drush
include_recipe "mblwhoi_drupal::drush"

# Raise error if no capistrano attribute is present.
if ( 
    ! node.attribute?("dla_web") ||
    ! node.dla_web.attribute?("capistrano") ||
    ! node.dla_web.capistrano.attribute?("user") ||
    ! node.dla_web.capistrano.user.attribute?("username")
    )

  raise "No dla_web[:capistrano] attributes.  At least dla_web[:capistrano][:user][:username] must be set."
end


# Save capistrano config.
cap_config = node[:dla_web][:capistrano].to_hash

# If secondary groups were not defined in capistrano config, set to the apache user.
cap_config["user"]["secondary_groups"] = cap_config["user"]["secondary_groups"] ? cap_config["user"]["secondary_groups"] : [ node[:apache][:user] ]

# Create a user to use for capistrano deployments.
mblwhoi_capistrano_user "create mblwhoi capistrano user" do
  user cap_config["user"]
end

# Enable apache modules.
apache_module "rewrite" do
end

# Create web dir.
directory "web_dir" do
  path "#{node[:dla_web][:web_dir]}"
  action :create
  mode 0755
  owner "root"
  group "root"
end

# Create htdocs dir.
directory "htdocs dir" do
  path "#{node[:dla_web][:docroot]}"
  action :create
  mode 0755
  owner "root"
  group "root"
end

# Create apps dir.
directory "apps dir" do
  path "#{node[:dla_web][:apps_dir]}"
  action :create
  mode 0755
  owner "root"
  group "root"
end

# Make apache config file.
web_app "#{node[:dla_web][:server_name]}" do
  template "dla_web.conf.erb"
  docroot node[:dla_web][:docroot]
  server_name node[:dla_web][:server_name]
  server_aliases node[:dla_web][:server_aliases] || [node[:dla_web][:server_name]]
end

# Create dla home app environment.
mblwhoi_drupal_app :dla do
  capistrano_user "#{node[:dla_web][:capistrano][:user][:username]}"
  app_dir "#{node[:dla_web][:apps_dir]}/dla_home"
  symlink "#{node[:dla_web][:docroot]}/dla"
end

# Create cruises app.
mblwhoi_drupal_app :dla_cruises do
  capistrano_user "#{node[:dla_web][:capistrano][:user][:username]}"
  app_dir "#{node[:dla_web][:apps_dir]}/cruises"
  symlink "#{node[:dla_web][:docroot]}/cruises"
end

# Create dla manuscripts app environment.
mblwhoi_drupal_app :manuscripts do
  capistrano_user "#{node[:dla_web][:capistrano][:user][:username]}"
  app_dir "#{node[:dla_web][:apps_dir]}/manuscripts"
  symlink "#{node[:dla_web][:docroot]}/manuscripts"
end

# Create ndsf_bibliography app environment.
mblwhoi_drupal_app :ndsf_bibliography do
  capistrano_user "#{node[:dla_web][:capistrano][:user][:username]}"
  app_dir "#{node[:dla_web][:apps_dir]}/ndsf_bibliography"
  symlink "#{node[:dla_web][:docroot]}/ndsf_bibliography"
end

# Create oral_histories app environment.
mblwhoi_drupal_app :oral_histories do
  capistrano_user "#{node[:dla_web][:capistrano][:user][:username]}"
  app_dir "#{node[:dla_web][:apps_dir]}/oral_histories"
  symlink "#{node[:dla_web][:docroot]}/oral_histories"
end

# Create ships app environment.
mblwhoi_drupal_app :ships do
  capistrano_user "#{node[:dla_web][:capistrano][:user][:username]}"
  app_dir "#{node[:dla_web][:apps_dir]}/ships"
  symlink "#{node[:dla_web][:docroot]}/ships"
end

# Create whoi av app environment.
mblwhoi_drupal_app :whoi_av do
  capistrano_user "#{node[:dla_web][:capistrano][:user][:username]}"
  app_dir "#{node[:dla_web][:apps_dir]}/whoi_av"
  symlink "#{node[:dla_web][:docroot]}/whoi_av"
end

# Create whoi historical_data app environment.
mblwhoi_drupal_app :historical_data do
  capistrano_user "#{node[:dla_web][:capistrano][:user][:username]}"
  app_dir "#{node[:dla_web][:apps_dir]}/historical_data"
  symlink "#{node[:dla_web][:docroot]}/historical_data"
end


# Create water temperatures app environment.
mblwhoi_static_app :water_temperatures do
  capistrano_user "#{node[:dla_web][:capistrano][:user][:username]}"
  app_dir "#{node[:dla_web][:apps_dir]}/water_temperatures"
  symlink "#{node[:dla_web][:docroot]}/water_temperatures"
end

# Create water temperatures app environment.
mblwhoi_static_app :lightships do
  capistrano_user "#{node[:dla_web][:capistrano][:user][:username]}"
  app_dir "#{node[:dla_web][:apps_dir]}/lightships"
  symlink "#{node[:dla_web][:docroot]}/lightships"
end


# Create legacy ships app environment.
mblwhoi_static_app :whoi_ships_penfield do
  capistrano_user "#{node[:dla_web][:capistrano][:user][:username]}"
  app_dir "#{node[:dla_web][:apps_dir]}/whoi_ships_penfield"
  symlink "#{node[:dla_web][:docroot]}/whoi_ships_penfield"
end


