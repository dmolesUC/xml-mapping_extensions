require_relative 'node_base'

require 'mime-types'

module XML
  module MappingExtensions
    class MimeTypeNode < NodeBase
      def to_value(xml_text)
        if (mt = MIME::Types[xml_text].first)
          mt
        else
          MIME::Type.new(xml_text)
        end
      end
    end
    ::XML::Mapping.add_node_class MimeTypeNode
  end
end
