#
# Cookbook Name:: mblwhoi_static_app
# Definition:: mblwhoi_static_app
# 

define :mblwhoi_static_app do

  # Params.  We list them here to make them explicit
  # and to make shortcut handles.
  app_name = params[:app_name] || params[:name]
  app_dir = params[:app_dir]
  symlink = params[:symlink]
  app_owner = params[:app_owner]
  app_group = params[:app_group]
  app_repo = params[:app_repo]
  app_branch = params[:app_branch]

  # Create deploy_dir for the app, if it does not already exist.
  directory "#{app_dir}" do
    mode "0775"
    owner app_owner
    group app_group
    action :create
  end

  # Create shared resources dir
  directory "#{app_dir}/shared" do
    mode "0775"
    owner app_owner
    group app_group
    action :create
  end

  # Create app's symlink.
  link "#{symlink} symlink" do
    target_file symlink
    to "#{app_dir}/current"
    owner app_owner
    group app_group
  end

end



