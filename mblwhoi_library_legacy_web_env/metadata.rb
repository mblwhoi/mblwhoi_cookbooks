maintainer       "adorsk-whoi"
maintainer_email "adorsk@whoi.edu"
license          "All rights reserved"
description      "Installs/Configures environment for MBLWHOI Library Legacy website."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"


%w{mblwhoi_vhost_env}.each do |cb|
  depends cb
end
