require_relative 'node_base'

require 'ruby-enum'

module XML
  module MappingExtensions

    # Base class for single-attribute nodes with `Ruby::Enum` values
    #
    # Usage:
    #   - extend this class
    #   - add an `ENUM_CLASS` constant whose value is the `Ruby::Enum` class
    #     to be mapped
    #   - call `::XML::Mapping.add_node_class` to add your new node class
    class EnumNodeBase < NodeBase

      def to_value(xml_text)
        enum_class = self.class::ENUM_CLASS
        enum_class.parse(xml_text)
      end

      def to_xml_text(value)
        value.to_s
      end

    end
  end
end
