maintainer       "adorsk-whoi"
maintainer_email "adorsk@whoi.edu"
license          "All rights reserved"
description      "Installs/Configures environment for MBLWHOI Library website."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"


%w{mblwhoi_drupal_app mblwhoi_static_app apache2}.each do |cb|
  depends cb
end