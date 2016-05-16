require 'uri'

module XML
  module MappingExtensions
    # Extends `XML::Mapping` to add a namespace attribute and write the namespace
    # out when saving to XML.
    class Namespaced

      class << self
        def namespace(ns = nil)
          @namespace = ns if ns
          @namespace
        end
      end

      def namespace
        self.class.namespace
      end

      def self.inherited(base)
        base.send(:include, ::XML::Mapping)
        base.send(:include, Injectors)
      end

      module Injectors
        # Overrides `XML::Mapping#pre_save` to set the XML namespace and schema location
        # on the generated element.
        def pre_save(options = {mapping: :_default})
          xml = super(options)
          namespace.set_default_namespace(xml) if namespace
          xml
        end

        # Overrides `XML::Mapping#save_to_xml` to set the XML namespace prefix on
        # the generated element, and all its descendants that have that namespace.
        def save_to_xml(options = {mapping: :_default})
          xml = super(options)
          namespace.set_prefix(xml) if namespace
          xml
        end
      end
    end
  end
end
