require_relative 'node_base'

require 'uri'

module XML
  module MappingExtensions
    # Coverts URI strings to `URI` objects.
    class UriNode < NodeBase
      # @param xml_text [String] the URI string to convert
      # @return [URI] the URI
      # @raise [URI::InvalidURIError] if `xml_text` is not a valid URI.
      def to_value(xml_text)
        URI(xml_text.strip)
      end
    end
    ::XML::Mapping.add_node_class UriNode
  end
end
