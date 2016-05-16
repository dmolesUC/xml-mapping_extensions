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
    end
  end
end
