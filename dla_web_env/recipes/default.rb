#
# Cookbook Name:: dla_web_env
# Recipe:: default
#
# Main setup recipe for dla.whoi.edu website environment.



# For each dla_webserver drupal app...
node[:dla_webserver][:drupal_apps].each do |app_id, app_config|
  
  # Create drupal app environment for the app.  (db, deployment dirs, config file).
  mblwhoi_drupal_app "drupal app #{app_id}" do
    name app_config.fetch("app_name", app_id)
    app_dir "#{node[:dla_webserver][:apps_dir]}/app_id" % app_config.fetch("app_dir", app_id)
    symlink "#{node[:dla_webserver][:docroot_dir]}/%s" % app_config.fetch("symlink", "app_id")
    app_owner = "#{node[:dla_webserver][:app_owner]}/%s"
    app_group = "#{node[:dla_webserver][:app_group]}/%s"
    app_repo = app_config[:repo]
    app_branch = app_config[:branch] || "master"
  end

end
