#
# Cookbook Name:: mblwhoilibrary_web_env
# Recipe:: default
#
# Main setup recipe for MBLWHOI Library Website environment.

# Include recipe dependencies.
# Dependencies will include sub-dependencies in turn.
include_recipe %w{mblwhoi_drupal mblwhoi_capistrano}

# Raise error if no capistrano attribute is present.
if ( 
    ! node.attribute?("mblwhoilibrary_web") ||
    ! node.mblwhoilibrary_web.attribute?("capistrano") ||
    ! node.mblwhoilibrary_web.capistrano.attribute?("user") ||
    ! node.mblwhoilibrary_web.capistrano.user.attribute?("username")
    )

  raise "No mblwhoilibrary_web[:capistrano] attributes.  At least mblwhoilibrary_web[:capistrano][:user][:username] must be set."
end


# Save capistrano config.
cap_config = node[:mblwhoilibrary_web][:capistrano].to_hash

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
  path "#{node[:mblwhoilibrary_web][:web_dir]}"
  action :create
  mode 0755
  owner "root"
  group "root"
end

# Create apps dir.
directory "apps dir" do
  path "#{node[:mblwhoilibrary_web][:apps_dir]}"
  action :create
  mode 0755
  owner "root"
  group "root"
end

# Make apache config file.
web_app "#{node[:mblwhoilibrary_web][:server_name]}" do
  template "mblwhoilibrary_web.conf.erb"
  docroot node[:mblwhoilibrary_web][:docroot]
  server_name node[:mblwhoilibrary_web][:server_name]
  server_aliases node[:mblwhoilibrary_web][:server_aliases]
end

# Create mblwhoilibrary drupal app environment
mblwhoi_drupal_app :mblwhoilibrary do
  capistrano_user "#{node[:mblwhoilibrary_web][:capistrano][:user][:username]}"
  app_dir "#{node[:mblwhoilibrary_web][:apps_dir]}/mblwhoilibrary"
  symlink "#{node[:mblwhoilibrary_web][:docroot]}"
end

# Install drush
include_recipe "mblwhoi_drupal::drush"
