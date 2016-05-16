require 'spec_helper'

require 'xml/mapping_extensions/namespace'

module XML
  module MappingExtensions

    UNPREFIXED = Namespace.new(uri: 'http://example.org/nse')
    PREFIXED   = Namespace.new(uri: 'http://example.org/nse', prefix: 'px')

    # TODO: both versions with schema location

    class Unprefixed
      include Namespaced
      namespace UNPREFIXED
      root_element_name 'unprefixed'
      text_node :attr, '@attr'
      text_node :text, 'text()'
    end

    class Prefixed
      include Namespaced
      namespace PREFIXED
      root_element_name 'prefixed'
      text_node :attr, '@attr'
      text_node :text, 'text()'
    end

    describe Namespaced do
      describe '#save_to_xml' do
        it 'writes XML with a default namespace' do
          obj = Unprefixed.new
          obj.attr = 'attr value'
          obj.text = 'text value'
          expected = '<unprefixed xmlns="http://example.org/nse" attr="attr value">text value</unprefixed>'
          expect(obj.write_xml).to be_xml(expected)
        end
        it 'writes XML with a prefixed namespace' do
          obj = Prefixed.new
          obj.attr = 'attr value'
          obj.text = 'text value'
          expected = '<px:prefixed xmlns:px="http://example.org/nse" attr="attr value">text value</unprefixed>'
          expect(obj.write_xml).to be_xml(expected)
        end
      end

      describe '#parse_xml' do
        it 'parses XML with a default namespace'
        it 'parses XML with a prefixed namespace'
      end

      describe 'namespace' do
        it 'takes a string' do
          class StringNS
            include Namespaced

            namespace 'http://example.org/string-ns'
          end

          expect(StringNS.namespace).to eq(Namespace.new(uri: 'http://example.org/string-ns'))
        end

        it 'takes an array' do
          class MultipleNS
            include Namespaced

            namespace([
              Namespace.new(uri: 'http://example.org/ns1'),
              Namespace.new(uri: 'http://example.org/ns2', prefix: 'ns2'),
              Namespace.new(uri: 'http://example.org/ns3', prefix: 'ns3', schema_location: 'http://example.org/ns3.xsd'),
              Namespace.new(uri: 'http://example.org/ns4', prefix: 'ns4', schema_location: 'http://example.org/ns4.xsd')
            ])

            root_element_name 'multi'
            text_node :attr, '@attr'
            text_node :text, 'text()'
          end

          obj = MultipleNS.new
          obj.attr = 'attr value'
          obj.text = 'text value'

          expected = '<multi
            xmlns="http://example.org/ns1"
            xmlns:ns2="http://example.org/ns2"
            xmlns:ns3="http://example.org/ns3"
            xmlns:ns4="http://example.org/ns4"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://example.org/ns3 http://example.org/ns3.xsd http://example.org/ns4 http://example.org/ns4.xsd"
          </multi>'

          expect(obj.write_xml).to be_xml(expected)
        end
      end

    end
  end
end
