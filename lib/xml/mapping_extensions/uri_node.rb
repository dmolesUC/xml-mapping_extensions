require_relative 'node_base'

require 'uri'

module XML
  module MappingExtensions
    class UriNode < NodeBase
      def to_value(xml_text)
        URI(xml_text.strip)
      end
    end
    ::XML::Mapping.add_node_class UriNode
  end
end
