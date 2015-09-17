require_relative 'node_base'

require 'time'

module XML
  module MappingExtensions
    # XML mapping for XML Schema dates.
    # Known limitation: loses time zone info
    class DateNode < NodeBase

      # param xml_text [String] an XML Schema date
      # @return [Date] the value as a `Date`
      def to_value(xml_text)
        Date.xmlschema(xml_text)
      end

      # @param value [Date] the value as a `Date`
      # @return [String] the value as an XML Schema date string, without
      #   time zone information
      def to_xml_text(value)
        value.xmlschema
      end
    end
    ::XML::Mapping.add_node_class DateNode
  end
end
