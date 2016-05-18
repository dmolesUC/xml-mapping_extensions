require 'uri'

module XML
  module MappingExtensions

    # Encapsulates an XML namespace with a URI, schema location, and optional prefix.
    class Namespace

      # @return [String] the string form of the namespace URI
      attr_reader :uri

      # @return [String, nil] the namespace prefix
      attr_reader :prefix

      # @return [URI, String, nil] the schema location URI
      attr_reader :schema_location

      # Creates a new {Namespace}
      # @param uri [URI, String] the namespace URI
      # @param prefix [String, nil] the namespace prefix
      # @param schema_location [String, nil] the schema location
      # @raise [URI::InvalidURIError] if `uri` is nil, or a string that is not a valid URI
      # @raise [URI::InvalidURIError] if `schema_location` is a string that is not a valid URI
      def initialize(uri:, prefix: nil, schema_location: nil)
        fail URI::InvalidURIError, 'uri cannot be nil' unless uri
        @uri             = MappingExtensions.to_uri_str(uri)
        @prefix          = prefix
        @schema_location = MappingExtensions.to_uri_str(schema_location)
      end

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
    end
  end
end
