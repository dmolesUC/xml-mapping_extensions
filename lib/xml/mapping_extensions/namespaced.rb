require 'uri'

module XML
  module MappingExtensions
    # Extends `XML::Mapping` to add a `namespace` attribute and write the namespace
    # out when saving to XML.
    module Namespaced

      def self.included(base)
        base.extend(ClassMethods)
        base.include(XML::Mapping)
        base.include(InstanceMethods)
      end

      module ClassMethods
        def namespace(ns = nil)
          @namespace = ns if ns
          @namespace
        end
      end

      def namespace
        self.class.namespace
      end

      # Hack to make sure these don't get defined till after `XML::Mapping`'s include
      # hooks have a chance to define their super methods
      module InstanceMethods

        # Overrides `XML::Mapping#fill_into_xml` to set the XML namespace
        def fill_into_xml(xml, options = { mapping: :_default })
          add_namespace(xml)
          super(xml, options)
          set_prefix_recursive(namespace.prefix, xml)
        end

        private

        def set_prefix_recursive(prefix, elem)
          return unless prefix
          set_prefix(prefix, elem)
          elem.each_element { |e| set_prefix_recursive(prefix, e) }
          elem
        end

        def add_namespace(elem)
          return unless namespace
          prefix, uri, schema_location = namespace.prefix, namespace.uri, namespace.schema_location # rubocop:disable Style/ParallelAssignment
          root                         = add_schema_location(uri, schema_location, elem.root)
          if prefix
            set_prefix(prefix, elem)
            root.add_namespace(prefix, uri)
          else
            root.add_namespace(uri)
          end
        end

        def set_prefix(prefix, elem)
          # name= with a prefixed name sets namespace by side effect and is the only way to actually output the prefix
          elem.name = "#{prefix}:#{elem.name}" if elem.prefix.to_s.empty?
        end

        def add_schema_location(uri, schema_location, elem)
          return elem unless schema_location

          schema_location_attr = elem.attribute('xsi:schemaLocation')
          all_declarations     = schema_location_attr ? schema_location_attr.value : ''

          declaration = "#{uri} #{schema_location}"
          return elem if all_declarations.include?(declaration)

          all_declarations << " #{declaration}"
          elem.add_attribute('xsi:schemaLocation', all_declarations.strip)
          elem.add_namespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
        end

      end
    end
  end
end
