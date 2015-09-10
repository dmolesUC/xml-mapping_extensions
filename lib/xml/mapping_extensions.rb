# Additional mapping nodes and other utility classes for working with
# [XML::Mapping](http://multi-io.github.io/xml-mapping/)
module Resync
  Dir.glob(File.expand_path('../mapping_extensions/*.rb', __FILE__), &method(:require))
end
