require 'xml/mapping'

module XML
  module MappingExtensions

    # Base class for simple single-attribute nodes that convert
    # XML strings to object values.
    #
    # Usage:
    #   - extend this class
    #   - override `to_value` (and, optionally, `to_xml_text`) to do your conversion
    #   - call `::XML::Mapping.add_node_class` to add your new node class
    class NodeBase < ::XML::Mapping::SingleAttributeNode

      # See `::XML::Mapping::SingleAttributeNode#initialize`
      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      # Implements `::XML::Mapping::SingleAttributeNode#extract_attr_value`.
      # @param xml [Element] The XML element to extract the value from
      # @return [Object, nil] the mapped value, or nil if
      def extract_attr_value(xml)
        xml_text = default_when_xpath_err { @path.first(xml).text }
        to_value(xml_text) if xml_text
      rescue => e
        bad_value = xml_text ? "'#{xml_text}'" : 'nil'
        raise e, "#{@owner}.#{@attrname}: Can't parse #{bad_value} as #{self.class}: #{e.message}"
      end

      # Implements `::XML::Mapping::SingleAttributeNode#set_attr_value`.
      # The object value is passed to `to_xml_text` for string conversion.
      # @param xml [Element] The XML element to write to
      # @param value [Object] The value to write
      def set_attr_value(xml, value)
        text = to_xml_text(value)
        @path.first(xml, ensure_created: true).text = text
      end

      # Override this method to convert XML text to an object value
      # @param xml_text [String] The XML string to parse
      # @return [Object] The object value
      def to_value(xml_text) # rubocop:disable Lint/UnusedMethodArgument
        raise NoMethodError, "#{self.class} should override #to_value to convert an XML string to an object value"
      end

      # Override this method to convert object values to XML text.
      # The default implementation simply calls `to_s`.
      # @param value [Object] The object value to convert
      # @return [String] The XML string to write
      def to_xml_text(value)
        value.to_s
      end

    end
  end
end
