require_relative 'node_base'

require 'typesafe_enum'

module XML
  module MappingExtensions

    # Base class for single-attribute nodes with values that extend `TypesafeEnum::Base`
    #
    # Usage:
    #     # for node class MyEnum
    #     typesafe_enum_node :my_enum, '@my_enum', default_value: nil, class: MyEnum
    class TypesafeEnumNode < NodeBase
      def initialize(*args)
        super
        @enum_class = @options[:class]
        fail ArgumentError, "No :class found for TypesafeEnumNode #{@attrname} of #{@owner}" unless @enum_class
      end

      def to_value(xml_text)
        enum_instance = @enum_class.find_by_value(xml_text)
        enum_instance = @enum_class.find_by_value_str(xml_text) unless enum_instance
        enum_instance
      end

      def to_xml_text(enum_instance)
        enum_instance.value.to_s if enum_instance
      end
    end
    ::XML::Mapping.add_node_class TypesafeEnumNode
  end
end
