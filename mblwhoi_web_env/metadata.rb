maintainer       "adorsk-whoi"
maintainer_email "adorsk@whoi.edu"
license          "All rights reserved"
description      "Installs/Configures MBLWHOI Web Environment."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{apache2 mysql php mblwhoi_capistrano mblwhoi_drupal mblwhoi_static_app}.each do |cb|
  depends cb
end

%w{ debian ubuntu }.each do |os|
  supports os
end
