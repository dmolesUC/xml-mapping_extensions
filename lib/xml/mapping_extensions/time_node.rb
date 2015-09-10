require_relative 'node_base'

module XML
  module MappingExtensions

    # Maps `Time` objects to ISO 8601 strings.
    class TimeNode < NodeBase

      # param xml_text [String] an ISO 8601 datetime value
      # @return [Time] the value as a UTC `Time`
      def to_value(xml_text)
        Time.iso8601(xml_text).utc
      end

      # @param value [Time] the value as a `Time`
      # @return the value as an ISO 8601 string
      def to_xml_text(value)
        value.utc.iso8601
      end
    end
    ::XML::Mapping.add_node_class TimeNode

  end
end
