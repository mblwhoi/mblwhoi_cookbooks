#
# Cookbook Name:: mblwhoi_library_legacy_web_env
# Recipe:: default
#
# Main setup recipe for mblwhoi library website environment.

# Include dependencies.
include_recipe %w{mblwhoi_drupal_app mblwhoi_static_app}

# Make legacy root dir.
directory "mblwhoi library legacy root dir" do
  path node[:mblwhoi_library_legacy_webserver][:root_dir]
  mode "0755"
  owner node[:mblwhoi_library_legacy_webserver][:app_owner]
  owner node[:mblwhoi_library_legacy_webserver][:app_owner]
  recursive true
  action :create
end


# Note: we do not make a docroot dir for the mblwhoi library site.  The mblwhoi library drupal app becomes the docroot.

# Make apps dir.
directory "mblwhoi library apps dir" do
  path node[:mblwhoi_library_legacy_webserver][:apps_dir]
  mode "0755"
  owner node[:mblwhoi_library_legacy_webserver][:app_owner]
  owner node[:mblwhoi_library_legacy_webserver][:app_group]
  action :create
end


# Make apache config.
web_app "#{node[:mblwhoi_library_legacy_webserver][:server_name]}" do
  template "mblwhoi_library_web.conf.erb"
  docroot node[:mblwhoi_library_legacy_webserver][:docroot_dir]
  server_name node[:mblwhoi_library_legacy_webserver][:server_name]
  server_aliases node[:mblwhoi_library_legacy_webserver][:server_aliases] || [node[:mblwhoi_library_legacy_webserver][:server_name]]
end




# For each mblwhoi_library_legacy_webserver drupal app...
node[:mblwhoi_library_legacy_webserver][:drupal_apps].each do |app_id, app_config|
  
  # Create drupal app environment for the app.  (db, deployment dirs, code, config file).
  mblwhoi_drupal_app "drupal app #{app_id}" do
    app_name "%s" % app_config.fetch("app_name", app_id)
    app_dir "#{node[:mblwhoi_library_legacy_webserver][:apps_dir]}/%s" % app_config.fetch("app_dir", app_id)
    symlink "#{node[:mblwhoi_library_legacy_webserver][:docroot_dir]}/%s" % app_config.fetch("symlink_name", app_id)
    app_owner "#{node[:mblwhoi_library_legacy_webserver][:app_owner]}"
    app_group "#{node[:mblwhoi_library_legacy_webserver][:app_group]}"
    app_repo "#{app_config[:repo]}"
    app_branch "%s" % [app_config[:branch] || node[:mblwhoi_library_legacy_webserver][:default_branch] || "master"]
  end

end



# For each mblwhoi_library_legacy_webserver static app...
node[:mblwhoi_library_legacy_webserver][:static_apps].each do |app_id, app_config|
  
  # Create static app environment for the app. (deploy dir, code)
  mblwhoi_static_app "drupal app #{app_id}" do
    app_name "%s" % app_config.fetch("app_name", app_id)
    app_dir "#{node[:mblwhoi_library_legacy_webserver][:apps_dir]}/%s" % app_config.fetch("app_dir", app_id)
    symlink "#{node[:mblwhoi_library_legacy_webserver][:docroot_dir]}/%s" % app_config.fetch("symlink_name", app_id)
    app_owner "#{node[:mblwhoi_library_legacy_webserver][:app_owner]}"
    app_group "#{node[:mblwhoi_library_legacy_webserver][:app_group]}"
    app_repo "#{app_config[:repo]}"
    app_branch "%s" % [app_config[:branch] || "master"]
  end

end
