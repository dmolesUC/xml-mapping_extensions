require 'xml/mapping'

module XML
  module MappingExtensions

    # Base class for simple single-attribute nodes that convert
    # XML strings to object values.
    #
    # Usage:
    #   - extend this class
    #   - override `to_value` and `to_xml_text` to do your conversion
    #   - call `::XML::Mapping.add_node_class` to add your new node class
    class NodeBase < ::XML::Mapping::SingleAttributeNode

      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      # Implements `::XML::Mapping::SingleAttributeNode#extract_attr_value`.
      # @return [Object, nil] the mapped value, or nil if
      def extract_attr_value(xml)
        xml_text = default_when_xpath_err { @path.first(xml).text }
        to_value(xml_text) if xml_text
      end

      # Implements `::XML::Mapping::SingleAttributeNode#set_attr_value`.
      def set_attr_value(xml, value)
        text = to_xml_text(value)
        @path.first(xml, ensure_created: true).text = text
      end

      # @param _xml_text [String]
      def to_value(_xml_text)
        fail NoMethodError, "#{self.class} should override #to_value to convert an XML string to an object value"
      end

      # Override this method to convert object values to XML text.
      # @param _value [Object] The object value to convert
      def to_xml_text(_value)
        fail NoMethodError, "#{self.class} should override #to_xmL to convert an object value to an XML string"
      end

    end
  end
end
