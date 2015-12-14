require 'xml/mapping'

module XML
  # Additional mapping nodes and other utility classes for working with
  # [XML::Mapping](http://multi-io.github.io/xml-mapping/)
  module MappingExtensions
    Dir.glob(File.expand_path('../mapping_extensions/*.rb', __FILE__), &method(:require))
  end

  module Mapping

    # Writes this mapped object as an XML string.
    #
    # @param options [Hash] the options to be passed to
    #   [XML::Mapping#save_to_xml](http://multi-io.github.io/xml-mapping/XML/Mapping.html#method-i-save_to_xml)
    # @return [String] the XML form of the object, as a compact, pretty-printed string.
    def write_xml(options = { mapping: :_default })
      xml = save_to_xml(options)
      formatter = REXML::Formatters::Pretty.new
      formatter.compact = true
      io = StringIO.new
      formatter.write(xml, io)
      io.string
    end

    module ClassMethods
      # Create a new instance of this class from the XML contained in
      # `xml`, which can be a string, REXML document, or REXML element
      # @param xml [String, REXML::Document, REXML::Element]
      # @return [Object] an instance of this class.
      def parse_xml(xml)
        element = case xml
                  when REXML::Document
                    xml.root
                  when REXML::Element
                    xml
                  else
                    fail ArgumentError, "Unexpected argument type; expected XML document, String, or IO source, was #{xml.class}" unless can_parse(xml)
                    REXML::Document.new(xml).root
                  end
        load_from_xml(element)
      end

      private

      # Whether the argument can be parsed as an `REXML::Document`, i.e. whether
      # it is a `String` or something `IO`-like
      # @param arg [Object] a possibly-parsable object
      # @return [Boolean] true if `REXML::Document.new()` should be able to parse
      #   the argument, false otherwise
      def can_parse(arg)
        arg.is_a?(String) ||
          (arg.respond_to?(:read) &&
            arg.respond_to?(:readline) &&
            arg.respond_to?(:nil?) &&
            arg.respond_to?(:eof?))
      end
    end
  end
end
