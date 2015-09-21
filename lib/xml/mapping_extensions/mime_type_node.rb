require_relative 'node_base'

require 'mime-types'

module XML
  module MappingExtensions

    # Converts MIME type strings to `MIME::Type` objects
    class MimeTypeNode < NodeBase

      # Converts a MIME type string to a `MIME::Type` object,
      # either the first corresponding value in the `MIME::Types`
      # registry, or a newly created value.
      # @param xml_text the MIME type string
      # @return [MIME::Type] the corresponding `MIME::Type`
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
