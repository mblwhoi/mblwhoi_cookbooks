maintainer       "adorsk-whoi"
maintainer_email "adorsk@whoi.edu"
license          "All rights reserved"
description      "Installs/Configures environment for MBLWHOI Intranet webserver."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"


%w{mblwhoi_vhost_env apache2}.each do |cb|
  depends cb
end
