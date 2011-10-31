maintainer       "adorsk-whoi"
maintainer_email "adorsk@whoi.edu"
license          "All rights reserved"
description      "Definitions for MBLWHOI Drupal Apps"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{mysql openssl backup whenever}.each do |cb|
  depends cb
end

