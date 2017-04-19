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

      # Creates a new {TypesafeEnumNode}
      # @param :class the enum class
      def initialize(*args)
        super
        @enum_class = @options[:class]
        raise ArgumentError, "No :class found for TypesafeEnumNode #{@attrname} of #{@owner}" unless @enum_class
      end

      # Converts an enum value or value string to an enum instance
      # @param xml_text [String, nil] the enum value or value string
      # @return [TypesafeEnum::Base, nil] an instance of the enum class declared in the initializer,
      #   or nil if `xml_text` is nil
      def to_value(xml_text)
        return nil unless xml_text
        enum_instance = @enum_class.find_by_value(xml_text)
        enum_instance = @enum_class.find_by_value_str(xml_text) unless enum_instance
        raise ArgumentError, "No instance of enum class #{@enum_class.name} found for value '#{xml_text}'" unless enum_instance
        enum_instance
      end

      # Converts an enum value or value string to an enum instance
      # @param enum_instance [TypesafeEnum::Base, nil] an instance of the enum class declared in the initializer
      # @return [String, nil] the enum value as a string, or nil if `enum_instance` is nil
      def to_xml_text(enum_instance)
        enum_instance.value.to_s if enum_instance
      end
    end
    ::XML::Mapping.add_node_class TypesafeEnumNode
  end
end
