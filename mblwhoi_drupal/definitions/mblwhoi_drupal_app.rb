#
# Cookbook Name:: mblwhoi_drupal
# Definition:: mblwhoi_drupal_app
# 
# Creates db, drupal folders, drupal settings.php file, and capistrano deployment dir for a drupal app.

define :mblwhoi_drupal_app do

  # Include dependencies.
  include_recipe %w{mysql mysql::server openssl mblwhoi_static_app}

  class Chef::Recipe
    include Opscode::OpenSSL::Password
  end

  Gem.clear_paths
  require 'mysql'
  
  # Get the application name.
  app_name = params[:name]

  # Get the capistrano user name.
  capistrano_user = params[:capistrano_user]

  # Get the app dir.
  app_dir = params[:app_dir]

  # Get the symlink path.
  symlink = params[:symlink]
  
  # Set the name of the database to create
  # We truncate this to 16 characters to avoid mysql errors.
  db_name = "#{app_name}".slice(0..15)

  # Set the name of the db user to create
  # We truncate this to 16 characters to avoid mysql errors.
  db_user = "#{app_name}".slice(0..15)

  # Create a random password for the db user
  # Note: secure_password comes from Opscode:OpenSSL::Password
  db_pass = secure_password 

  # Create app dir from static app definition.
  mblwhoi_static_app "#{app_dir}" do
    capistrano_user capistrano_user
    app_dir app_dir
    symlink symlink
  end

  # Create sites dir within the shared resources dir.
  directory "#{app_dir}/shared/sites" do
    mode "0775"
    owner capistrano_user
    group "#{node[:apache][:user]}"
    action :create
  end

  # Create sites/default
  directory "#{app_dir}/shared/sites/default" do
    mode "0755"
    owner capistrano_user
    group "#{node[:apache][:user]}"
    action :create
  end


  # Create sites/default/files within the shared resources dir.
  directory "#{app_dir}/shared/sites/default/files" do
    mode "0775"
    owner capistrano_user
    group "#{node[:apache][:user]}"
    action :create
  end

  # Define log message to display after the environment has been created.
  log "Drupal environment has been created.  Deploy drupal site to #{app_dir}." do
    action :nothing
  end


  # Create settings.php file if it does not exist.
  # Will be triggered by db creation resource below.
  template "create settings.php" do
    path "#{app_dir}/shared/sites/default/settings.php"
    source "settings.php.erb"
    mode "0750"
    owner capistrano_user
    group "#{node[:apache][:user]}"
    cookbook "mblwhoi_drupal"
    variables(
              :database => db_name,
              :user => db_user,
              :password => db_pass
              )
    notifies :write, resources(:log => "Drupal environment has been created.  Deploy drupal site to #{app_dir}.")
    not_if "test -e #{app_dir}/shared/sites/default/settings.php"
  end

  # Create mysql user and grant permissions.
  # This is triggered by the db creation execute resource below.
  execute "mysql-install-drupal-privileges" do

    # Create sql string to execute.
    sql = "GRANT ALL ON %s.* TO '%s'@'%%' IDENTIFIED BY '%s'; FLUSH PRIVILEGES;" % [db_name, db_user, db_pass]

    # Execute sql command.
    command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -e \"#{sql}\""

    # Don't run it until notified.
    action :nothing

  end

  # Create a mysql db if the db does not exist.
  execute "create #{db_name} database" do
    command "/usr/bin/mysqladmin -u root -p#{node[:mysql][:server_root_password]} create #{db_name}"
    notifies :run, resources(:execute => "mysql-install-drupal-privileges")
    notifies :create, resources(:template => "create settings.php")
    not_if do
      m = Mysql.new("localhost", "root", node[:mysql][:server_root_password])
      m.list_dbs.include?("#{db_name}") # Note: have to convert symbol to string for proper comparison here.
    end
  end

  # Create hourly cron job.
  cron "drupal hourly cron" do
    command "cd #{app_dir}/current; /usr/bin/php cron.php"
    minute "0"
  end

end



