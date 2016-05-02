require 'uri'

module XML
  module MappingExtensions

    # Encapsulates an XML namespace with a URI, schema location, and optional prefix.
    class Namespace

      # @return [String] the string form of the namespace URI
      attr_reader :uri

      # @return [String, nil] the namespace prefix
      attr_reader :prefix

      # @return [String] the string form of the schema location URI
      attr_reader :schema_location

      # Creates a new {Namespace}
      # @param uri [URI, String] the namespace URI
      # @param prefix [String, nil] the namespace prefix
      # @param schema_location [URI, String] the schema location
      def initialize(uri:, prefix: nil, schema_location:)
        @uri = uri.to_s
        @prefix = prefix
        @schema_location = schema_location.to_s
      end

      # Sets `uri` as the default (no-prefix) namespace on `elem`, with
      # `schema_location` as the schema location.
      # @param elem [REXML::Element] The element to set the namespace on
      def set_default_namespace(elem)
        elem.add_namespace(uri)
        elem.add_namespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
        elem.add_attribute('xsi:schemaLocation', schema_location)
      end

      # Sets `prefix` as the prefix for namespace `uri` on the specified document
      # root element, and all its descendants that have that namespace.
      # @param root [REXML::Element] The document root to set the namespace on
      def set_prefix(root)
        return unless prefix
        set_prefix_recursive(root)
        root.add_namespace(nil) if root.attributes['xmlns'] == uri # clear the no-prefix namespace
        root.add_namespace(prefix, uri)
      end

      private

      def set_prefix_recursive(elem)
        return unless elem.namespace == uri
        # name= with a prefixed name sets namespace by side effect and is the only way to actually output the prefix
        elem.name = "#{prefix}:#{elem.name}"
        elem.each_element { |e| set_prefix_recursive(e) }
      end
    end
  end

  # Patches `XML::Mapping` to add a namespace attribute and write the namespace
  # out when saving to XML.
  module NamespacedElement

    # @return [Namespace, nil] the namespace, if any
    attr_accessor :namespace

    # Overrides `XML::Mapping#pre_save` to set the XML namespace and schema location
    # on the generated element.
    def pre_save(options = { mapping: :_default })
      xml = super(options)
      namespace.set_default_namespace(xml) if namespace
      xml
    end

    # Overrides `XML::Mapping#save_to_xml` to set the XML namespace prefix on
    # the generated element, and all its descendants that have that namespace.
    def save_to_xml(options = { mapping: :_default })
      xml = super(options)
      namespace.set_prefix(xml) if namespace
      xml
    end
  end

  module Mapping
    prepend NamespacedElement
  end
end
