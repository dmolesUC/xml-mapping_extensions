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
    end
  end
end
