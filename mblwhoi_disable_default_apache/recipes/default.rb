#
# Cookbook Name:: mblwhoi_disable_default_apache
# Recipe:: default
#
# Main recipe for disabling default apache site.
#

# Include dependencies.
include_recipe %w{apache2}

apache_site "default" do
  enable false
end
