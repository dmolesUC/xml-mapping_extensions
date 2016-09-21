require 'xml/mapping'
require 'stringio'

module XML
  # Additional mapping nodes and other utility classes for working with
  # [XML::Mapping](http://multi-io.github.io/xml-mapping/)
  module MappingExtensions
    Dir.glob(File.expand_path('../mapping_extensions/*.rb', __FILE__), &method(:require))

    # Ensures that the specified argument is a URI.
    # @param url [String, URI] The argument. If the argument is already
    #   a URI, it is returned unchanged; otherwise, the argument's string
    #   form (as returned by +`to_s`+) is parsed as a URI.
    # @return [nil, URI] +`nil`+ if +`url`+ is nil, otherwise the URI.
    # @raise [URI::InvalidURIError] if `url` is a string that is not a valid URI
    def self.to_uri(url)
      return nil unless url
      return url if url.is_a? URI
      stripped = url.respond_to?(:strip) ? url.strip : url.to_s.strip
      URI.parse(stripped)
    end

    # Ensures that the specified argument is a URI string.
    # @param url [String, URI] The argument. If the argument is already
    #   a URI, it is returned unchanged; otherwise, the argument's string
    #   form (as returned by +`to_s`+) is parsed as a URI.
    # @return [nil, String] +`nil`+ if +`url`+ is nil, otherwise the URI string.
    # @raise [URI::InvalidURIError] if `url` is a string that is not a valid URI
    def self.to_uri_str(url)
      uri = to_uri(url)
      uri && uri.to_s
    end
  end

  module Mapping

    # Writes this mapped object as a pretty-printed XML string.
    #
    # @param options [Hash] the options to be passed to
    #   [XML::Mapping#save_to_xml](http://multi-io.github.io/xml-mapping/XML/Mapping.html#method-i-save_to_xml)
    # @return [String] the XML form of the object, as a compact, pretty-printed string.
    def write_xml(options = { mapping: :_default })
      xml = save_to_xml(options)
      formatter = REXML::Formatters::Pretty.new
      formatter.compact = true
      io = ::StringIO.new
      formatter.write(xml, io)
      io.string
    end

    # Writes this mapped object to the specified file, as an XML document (including declaration).
    #
    # @param path [String] The path of the file to write to
    # @param indent [Integer] The indentation level. Defaults to -1 (no indenting). Note
    #   that this parameter will be ignored if `pretty` is present.
    # @param pretty [Boolean] Whether to pretty-print the output. Defaults to `false`. Note
    #   that this option overrides `indent`.
    # @param options [Hash] the options to be passed to
    #   [XML::Mapping#save_to_xml](http://multi-io.github.io/xml-mapping/XML/Mapping.html#method-i-save_to_xml)
    def write_to_file(path, indent: -1, pretty: false, options: { mapping: :_default })
      doc = REXML::Document.new
      doc << REXML::XMLDecl.new
      doc.elements[1] = save_to_xml(options)
      File.open(path, 'w') do |f|
        return doc.write(f, indent) unless pretty
        formatter = REXML::Formatters::Pretty.new
        formatter.compact = true
        formatter.write(doc, f)
      end
    end

    # Additional accessors needed for `#fallback_mapping`.
    class Node
      attr_reader :attrname
      attr_accessor :mapping
    end

    # Monkey-patch ArrayNode to regenerate marshallers and unmarshallers after cloning
    class ArrayNode
      old_init = instance_method(:initialize)
      define_method(:initialize) do |*args|
        @init_args = args
        old_init.bind(self).call(*args)
      end

      define_method(:re_initialize) do |args|
        old_init.bind(self).call(*args)
      end

      attr_reader :init_args
      attr_accessor :options
    end

    module ClassMethods

      # Gets the configured root element names for this object.
      # @return [Hash[Symbol, String]] the root element names for this object, by mapping.
      attr_reader :root_element_names

      # Create a new instance of this class from the XML contained in
      # `xml`, which can be a string, REXML document, or REXML element
      # @param xml [String, REXML::Document, REXML::Element]
      # @return [Object] an instance of this class.
      def parse_xml(xml, options = { mapping: :_default })
        element = case xml
                  when REXML::Document
                    xml.root
                  when REXML::Element
                    xml
                  else
                    fail ArgumentError, "Unexpected argument type; expected XML document, String, or IO source, was #{xml.class}" unless can_parse(xml)
                    REXML::Document.new(xml).root
                  end
        load_from_xml(element, options)
      end

      # Configures one mapping as a fallback for another, allowing mappings
      # that differ e.g. from the default only in some small detail. Creates
      # mapping nodes based on the fallback for all attributes for which a
      # mapping node is present in the fallback but not in the primary, and
      # likewise sets the root element name for the primary to the root element
      # name for the fallback if it has not already been set.
      #
      # @param mapping [Symbol] the primary mapping
      # @param fallback [Symbol] the fallback mapping to be used if the primary
      #   mapping lacks a mapping node or root element name
      def fallback_mapping(mapping, fallback)
        mapping_nodes = add_fallback_nodes(nodes_by_attrname(mapping), mapping, fallback)
        xml_mapping_nodes_hash[mapping] = mapping_nodes.values

        return if root_element_names[mapping]
        fallback_name = root_element_names[fallback]
        root_element_name(fallback_name, mapping: mapping)
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

      # Returns the nodes for the specified mapping as a hash accessible by
      # their attribute names.
      # @param mapping [Symbol] the mapping
      # @return [Hash[Symbol, Node]] the nodes
      def nodes_by_attrname(mapping)
        nodes = xml_mapping_nodes(mapping: mapping)
        nodes.map { |node| [node.attrname, node] }.to_h
      end

      # Creates mapping nodes based on the fallback for all attributes for which a
      # mapping node is present in the fallback but not in the primary.
      # @param mapping_nodes [Hash[Symbol, Node]] The primary nodes
      # @param mapping [Symbol] The primary mapping
      # @param fallback [Symbol] The fallback mapping
      def add_fallback_nodes(mapping_nodes, mapping, fallback)
        all_nodes = nodes_by_attrname(fallback).map do |attrname, fallback_node|
          [attrname, clone_node(fallback_node, mapping)]
        end.to_h
        all_nodes.merge!(mapping_nodes)
      end

      def clone_node(fallback_node, new_mapping)
        node = fallback_node.clone
        node.mapping = new_mapping
        if node.is_a?(ArrayNode)
          args = node.init_args.clone
          options = args.pop.clone
          options[:mapping] = new_mapping
          args << options
          node.re_initialize(args)
        end
        node
      end
    end
  end
end
