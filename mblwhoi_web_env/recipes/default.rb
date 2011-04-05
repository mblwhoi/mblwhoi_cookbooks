#
# Cookbook Name:: mblwhoilibrary_web_env
# Recipe:: default
#
# Main setup recipe for MBLWHOI Library Website environment.

# Include recipe dependencies.
# Dependencies will include sub-dependencies in turn.
include_recipe %w{apache2 mysql mysql::server php}


# Install php5-mysql
php_mysql = package "php5-mysql" do
  package_name value_for_platform(
    "debian" => {
      "5.0.5" => "php5-mysql"
    },
    "ubuntu" => {
      "9.10" => "php5-mysql"
    },
    "default" => 'php5-mysql'
  )
  action :nothing
end

php_mysql.run_action(:install)

# Install php5-ldap
php_ldap = package "php5-ldap" do
  package_name value_for_platform(
    "debian" => {
      "5.0.5" => "php5-ldap"
    },
    "ubuntu" => {
      "9.10" => "php5-ldap"
    },
    "default" => 'php5-ldap'
  )
  action :nothing
end

php_ldap.run_action(:install)


# Install php5 gd module.
php_gd = package "php5-gd" do
  package_name value_for_platform(
    "debian" => {
      "5.0.5" => "php5-gd"
    },
    "ubuntu" => {
      "9.10" => "php5-gd"
    },
    "default" => 'php5-gd'
  )
  action :nothing
end

php_gd.run_action(:install)


# Disable apache default site.
apache_site "default" do
  enable false
end
