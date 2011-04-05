#
# Cookbook Name:: mblwhoi_static_app
# Definition:: mblwhoi_static_app
# 
# Creates capistrano deployment dir for a static app.

define :mblwhoi_static_app do

  # Get the application name.
  app_name = params[:name]

  # Get the capistrano user name.
  capistrano_user = params[:capistrano_user]

  # Get the app dir.
  app_dir = params[:app_dir]

  # Get the symlink path.
  symlink = params[:symlink]

  # Create app dir.  Have it be owned by the capistrano user.
  directory app_dir do
    owner capistrano_user
    group capistrano_user
    mode "0775"
    action :create
  end

  # Create releases dir.
  directory "#{app_dir}/releases" do
    owner capistrano_user
    group capistrano_user
    mode "0775"
    action :create
  end

  # Create a symlink to the app's current release,
  # if the symlink does not exist yet.
  execute "create-symlink" do
    command "ln -snf #{app_dir}/current #{symlink}"
    not_if "test -L #{symlink}"
  end

  # Create shared resources dir.
  directory "#{app_dir}/shared" do
    mode "0775"
    owner capistrano_user
    group capistrano_user
    action :create
  end

end



