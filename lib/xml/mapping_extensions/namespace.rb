require 'uri'

module XML
  module MappingExtensions

    # Encapsulates an XML namespace with a URI, schema location, and optional prefix.
    class Namespace

      # @return [String] the string form of the namespace URI
      attr_reader :uri

      # @return [String, nil] the namespace prefix
      attr_reader :prefix

      # @return [String, nil] the schema location URI(s), as a space-separated string list
      attr_reader :schema_location

      # Creates a new {Namespace}
      # @param uri [URI, String] the namespace URI
      # @param prefix [String, nil] the namespace prefix
      # @param schema_location [String, nil] the schema location(s)
      def initialize(uri:, prefix: nil, schema_location: nil)
        @uri             = uri.to_s
        @prefix          = prefix
        @schema_location = schema_location
      end

      # # Sets `uri` as the default (no-prefix) namespace on `elem`, with
      # # `schema_location` as the schema location.
      # # @param elem [REXML::Element] The element to set the namespace on
      # def set_default_namespace(elem) # rubocop:disable Style/AccessorMethodName
      #   elem.add_namespace(uri)
      #   return unless schema_location
      #   set_schema_location(elem)
      #   elem.add_namespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
      #   elem
      # end
      #
      # # Sets `prefix` as the prefix for namespace `uri` on the specified document
      # # root element, and all its descendants that have that namespace.
      # # @param root [REXML::Element] The document root to set the namespace on
      # def set_prefix(root) # rubocop:disable Style/AccessorMethodName
      #   return unless prefix
      #   set_prefix_recursive(root)
      #   root.add_namespace(nil) if root.attributes['xmlns'] == uri # clear the no-prefix namespace
      #   root.add_namespace(prefix, uri)
      # end

      def to_s
        "Namespace(uri: #{uri}, prefix: #{prefix || 'nil'}, schema_location: #{schema_location || 'nil'}"
      end

      def ==(other)
        other.class == self.class && other.state == state
      end

      alias_method :eql?, :==

      def hash
        state.hash
      end

      protected

      def state
        [uri, prefix, schema_location]
      end

      # private
      #
      # def set_prefix_recursive(elem) # rubocop:disable Style/AccessorMethodName
      #   return unless elem.namespace == uri
      #   # name= with a prefixed name sets namespace by side effect and is the only way to actually output the prefix
      #   elem.name = "#{prefix}:#{elem.name}"
      #   elem.each_element { |e| set_prefix_recursive(e) }
      # end
      #
      # def set_schema_location(elem) # rubocop:disable Style/AccessorMethodName
      #   return unless schema_location
      #   existing = elem.attribute('xsi:schemaLocation')
      #   schema_locations = existing ? existing.value : ''
      #   schema_locations << " #{uri} #{schema_location}"
      #   elem.add_attribute('xsi:schemaLocation', schema_locations.strip)
      # end
    end
  end
end
