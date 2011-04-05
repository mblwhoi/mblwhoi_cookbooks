# Cookbook Name:: mblwhoi_drupal
# Recipe:: drush

# Copy drush files to node, at /usr/local/drush.
remote_directory "drush_files" do
  cookbook "mblwhoi_drupal"
  path "/usr/local/drush"
  source "drush"
  files_backup 0
  files_mode 0755
end

# Make symlink in /usr/local/bin to drush executable.
execute "create-symlink" do
  command "ln -snf /usr/local/drush/drush /usr/local/bin/drush"
  not_if "test -L /usr/local/bin/drush"
end
