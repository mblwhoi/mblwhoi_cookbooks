maintainer       "adorsk-whoi"
maintainer_email "adorsk@whoi.edu"
license          "All rights reserved"
description      "Definitions for MBLWHOI Drupal Apps"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{mysql openssl mblwhoi_static_app}.each do |cb|
  depends cb
end

%w{ debian ubuntu }.each do |os|
  supports os
end
