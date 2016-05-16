require 'spec_helper'

require 'xml/mapping_extensions/namespace'

module XML
  module MappingExtensions

    NSE_NS = Namespace.new(uri: 'http://example.org/nse')
    NSE_NS_PX = Namespace.new(uri: 'http://example.org/nse', prefix: 'nse')

    # TODO: both versions with schema location

    class NSEPXObject < NamespacedElement
      namespace NSE_NS_PX
      root_element_name 'nse'
      text_node :attr, '@attr'
      text_node :text, 'text()'
    end

    class NSEObject < NamespacedElement
      namespace NSE_NS
      root_element_name 'nse'
      text_node :attr, '@attr'
      text_node :text, 'text()'
    end

    describe NamespacedElement do
      describe '#save_to_xml' do
        it 'writes XML with a default namespace' do
          obj = NSEObject.new
          obj.attr = 'attr value'
          obj.text = 'text value'
          expected = '<nse xmlns="http://example.org/nse" attr="attr value">text value</nse>'
          expect(obj.write_xml).to be_xml(expected)
        end
        it 'writes XML with a prefixed namespace'
      end

      describe '#parse_xml' do
        it 'parses XML with a default namespace'
        it 'parses XML with a prefixed namespace'
      end
    end
  end
end
