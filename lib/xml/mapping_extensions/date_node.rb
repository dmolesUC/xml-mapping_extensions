require_relative 'node_base'

require 'time'

module XML
  module MappingExtensions
    # XML mapping for XML Schema dates.
    # Known limitation: loses time zone info (Ruby `Date` doesn't
    # support it)
    class DateNode < NodeBase
      # Whether date should be output with UTC "Zulu" time
      # designator ("Z")
      # @return [Boolean, nil] True if date should be output
      #   with "Z" time designator, false or nil otherwise
      def zulu
        @options[:zulu]
      end

      # Converts an XML Schema date string to a `Date` object
      # @param xml_text [String] an XML Schema date
      # @return [Date] the value as a `Date`
      def to_value(xml_text)
        Date.xmlschema(xml_text)
      end

      # Converts a `Date` object to an XML schema string
      # @param value [Date] the value as a `Date`
      # @return [String] the value as an XML Schema date string, without
      #   time zone information unless {#zulu} is set
      def to_xml_text(value)
        value = value.to_date if value.respond_to?(:to_date)
        text = value.iso8601 # use iso8601 instead of xmlschema in case of ActiveSupport shenanigans
        zulu && !text.end_with?('Z') ? "#{text}Z" : text
      end
    end
    ::XML::Mapping.add_node_class DateNode
  end
end
