#
# Cookbook Name:: mblwhoi_drupal
# Definition:: mblwhoi_drupal_app
# 
# Creates db, drupal folders, drupal settings.php file, and capistrano deployment dir for a drupal app.

define :mblwhoi_drupal_app do

  # Include dependencies.
  include_recipe %w{mysql mysql::server openssl}

  class Chef::Recipe
    include Opscode::OpenSSL::Password
  end

  Gem.clear_paths
  require 'mysql'
  
  # Params.  We list them here to make them explicit
  # and to make shortcut handles.
  app_name = params[:app_name] || params[:name]
  app_dir = params[:app_dir]
  symlink = params[:symlink]
  app_owner = params[:app_owner]
  app_group = params[:app_group]
  app_repo = params[:app_repo]
  app_branch = params[:app_branch]

  # Set the name of the database to create.
  # Same as app name by default.
  # We truncate this to 16 characters to avoid mysql errors.
  db_name = params.fetch('db_name', app_name)
  db_name = "#{db_name}".slice(0..15)

  # Set the name of the db user to create (same as db by default)
  db_user = params.fetch('db_user', db_name)

  # Create a random password for the db user
  # Note: secure_password comes from Opscode:OpenSSL::Password
  db_pass = params.fetch('db_pass', secure_password)

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

  # Create sites dir within the shared resources dir.
  directory "#{app_dir}/shared/sites" do
    mode "0775"
    owner app_owner
    group app_group
    action :create
  end

  # Create sites/default
  directory "#{app_dir}/shared/sites/default" do
    mode "0755"
    owner app_owner
    group app_group
    action :create
  end

  # Create sites/default/files within the shared resources dir.
  directory "#{app_dir}/shared/sites/default/files" do
    mode "0775"
    owner app_owner
    group app_group
    action :create
  end


  # Create settings.php file.
  # Will be triggered by db creation resource below.
  template "create settings.php" do
    path "#{app_dir}/shared/sites/default/settings.php"
    source "settings.php.erb"
    mode "0750"
    owner app_owner
    group app_group
    cookbook "mblwhoi_drupal"
    variables(
              :database => db_name,
              :user => db_user,
              :password => db_pass
              )
    action :nothing
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


  # Deploy app to app dir.
  deploy "deploy #{app_name}" do
    deploy_to app_dir
    user app_owner
    group app_group
    repo "#{app_repo}"
    branch "#{app_branch}"
    enable_submodules true
    shallow_clone true
    action :deploy
    migrate false
    create_dirs_before_symlink  %w{tmp public config deploy}
    symlink_before_migrate  "sites/default" => "sites/default"
    symlinks ({})

    # before_restart callback
    before_restart do
      
      # Make symlink from current/drupal_root to the htdocs dir
      execute "symlink to drupal root" do
        command "ln -nsf #{release_path}/drupal_root #{symlink}"
      end
    end
  end

  # Create hourly cron job.
  cron "drupal hourly cron" do
    command "cd #{symlink}; /usr/bin/php cron.php"
    minute "0"
  end

end



