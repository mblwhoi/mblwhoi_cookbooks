maintainer       "adorsk-whoi"
maintainer_email "adorsk@whoi.edu"
license          "All rights reserved"
description      "Definition for generic MBLWHOI Virtual Host Environment.  Creates web dirs, app dirs, apache config."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"


%w{mblwhoi_drupal_app apache2}.each do |cb|
  depends cb
end
