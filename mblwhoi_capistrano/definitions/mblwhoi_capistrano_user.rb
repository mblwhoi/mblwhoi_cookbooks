#
# Cookbook Name:: mblwhoi_capistrano
# Definition:: mblwhoi_capistrano_user
# 
# Creates capistrano user.

define :mblwhoi_capistrano_user do

  # Raise error if username attribute was given.
  if ( 
      ! params[:user] ||
      params[:user][:username].blank?
      )
    raise "No username.  Parameter 'user[:username]' must be set."
  end

  # Set default parameters.
  username = "#{params[:user][:username]}"
  home = params[:user]["home"] ? params[:user]["home"] : "/home/#{username}"
  gid = params[:user][:gid] ? params[:user]["gid"] : username
  secondary_groups = params[:user]["secondary_groups"]
  shell = params[:user]["shell"]
  password = params[:user]["password"]

  # Create home dir for user if creating new user.
  directory "Create capistrano user home dir" do
    path home
    owner username
    group gid
    action :nothing
  end
  

  # Create user if it does not exist yet.
  user "capistrano_user" do
    username "#{username}"
    comment "Capistrano User"
    home "#{home}"
    shell "#{shell}"
    notifies :create, resources(:directory => "Create capistrano user home dir")
    not_if "grep -q #{username} /etc/passwd"
  end

  # Set user's password if password was given.
  execute "set capistrano_user password" do
    command "usermod -p '#{password}' #{username}"
    not_if do
      password.nil?
    end
  end

  # Add to secondary groups.
  if ! secondary_groups.nil?
    params[:user][:secondary_groups].each do |g|
      execute "Add capistrano_user to #{g}" do
        command "usermod -a -G #{g} #{username}"
        not_if "groups #{username} | grep -q #{g}"
      end
    end
  end

end
